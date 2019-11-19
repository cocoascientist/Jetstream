//
//  WeatherService.swift
//  JetstreamKit
//
//  Created by Andrew Shepard on 8/17/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData
import Combine

public enum WeatherState {
    case unknown
    case latest(Weather)
}

public final class WeatherService {
    
    public var currentWeather: AnyPublisher<WeatherState, Never> {
        return _currentWeather.eraseToAnyPublisher()
    }
    private let _currentWeather: CurrentValueSubject<WeatherState, Never> = CurrentValueSubject(WeatherState.unknown)
    
    private let locationTracker = LocationTracker()
    public let dataStore: WeatherStore
    private let session: URLSession
    
    private var cancelables: [AnyCancellable] = []
    
    public init(dataController: CoreDataController = CoreDataController(),
                session: URLSession = URLSession.shared) {
        self.dataStore = WeatherStore(dataController: dataController)
        self.session = session
        
        bindToDataStoreInitialization()
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
    }
    
    private func bindToDataStoreInitialization() {
        dataStore.initializedDataStoreEvent
            .sink(
                receiveCompletion: { [weak self] (completion) in
                    switch completion {
                    case .finished:
                        self?.bindToDataStoreChanges()
                        self?.bindToLocationEvents()
                    case .failure(let error):
                        print("Error initialized data store: \(error)")
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelables)
    }
    
    private func bindToDataStoreChanges() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (notification) in
                self?.dataStore.managedObjectContext
                    .mergeChanges(fromContextDidSave: notification)
            }
            .store(in: &cancelables)
    }
    
    private func bindToLocationEvents() {
        let locationUpdateEvent = locationTracker.locationUpdateEvent
            .eraseToAnyPublisher()
            .share()
        
        locationUpdateEvent
            .compactMap { result -> Error? in
                guard case .failure(let error) = result else { return nil }
                return error
            }
            .sink { (error) in
                print("Unhandled error: \(error)")
            }
            .store(in: &cancelables)
        
        locationUpdateEvent
            .compactMap { result -> (Location, URLRequest)? in
                guard case .success(let location) = result else { return nil }
                let request = DarkSkyAPI.forecast(location.physical).request
                return (location, request)
            }
            .flatMap { (location, request) in
                return self.session.data(with: request)
                    .catch { _ in Just(Data()) }
                    .map { return (location, $0) }
            }
            .sink(receiveValue: { [weak self] (location, data) in
                guard let this = self else { return }
                let context = this.dataStore.backgroundManagedObjectContext

                let request = NSFetchRequest<Weather>(entityName: "Weather")
                if let result = try? context.fetch(request).first {
                    context.delete(result)
                }

                let decoder = JSONDecoder()
                decoder.userInfo[.context] = context
                decoder.userInfo[.location] = location

                if let weather = try? decoder.decode(Weather.self, from: data) {
                    this._currentWeather.send(.latest(weather))

                    do {
                        try context.save()
                        print("saved to context")
                    } catch {
                        print("unhandled error saving context: \(error)")
                    }
                }
            })
            .store(in: &cancelables)
    }
}
