//
//  LocationTracker.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Combine
import CoreLocation
import UIKit
import SwiftUI

enum LocationError: Error {
    case noData
    case other(Error)
}

final class LocationTracker: NSObject {
    
    /// Emits when the location has significantly changed
    lazy var locationChangeEvent: AnyPublisher<Location, Never> = {
        return _geocodedLocationEvent
            .compactMap { (result) -> Location? in
                switch result {
                case .success(let location):
                    return location
                case .failure:
                    return nil
                }
            }
            .eraseToAnyPublisher()
    }()
    
    lazy var locationErrorEvent: AnyPublisher<Error, Never> = {
        return _geocodedLocationEvent
            .compactMap { (result) -> Error? in
                switch result {
                case .success:
                    return nil
                case .failure(let error):
                    return error
                }
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var _geocodedLocationEvent: AnyPublisher<Result<Location, Error>, Never> = {
        self.locationManager
            .publisher()
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { (result) in
                return self.reverseGeocodingPublisher(for: result)
            }
            .eraseToAnyPublisher()
    }()
    
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder
    
    private var disposables: [AnyCancellable] = []
    
    init(locationManager: CLLocationManager = CLLocationManager(),geocoder: CLGeocoder = CLGeocoder()) {
        self.locationManager = locationManager
        self.geocoder = geocoder
        
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .map { _ in () }
            .sink(receiveValue: { [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            })
            .store(in: &disposables)
        
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .map { _ in () }
            .sink(receiveValue: { [weak self] _ in
                self?.locationManager.startUpdatingLocation()
            })
            .store(in: &disposables)
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        disposables.forEach { $0.cancel() }
    }
    
    // MARK: - Private
    
    private func reverseGeocodingPublisher(for result: Result<[CLLocation], Error>)
        -> AnyPublisher<Result<Location, Error>, Never> {

        switch result {
        case .failure(let error):
            return Just(Result<Location, Error>.failure(error))
                .eraseToAnyPublisher()
        
        case .success(let locations):
            guard let location = locations.first else {
                return Just(Result<Location, Error>.failure(LocationError.noData))
                    .eraseToAnyPublisher()
            }
            
            return geocoder
                .reverseGeocodingPublisher(for: location)
                .flatMap { (result) -> AnyPublisher<Result<Location, Error>, Never> in
                    switch result {
                    case .success(let placemarks):
                        return Just(placemarks.location(from: location))
                            .eraseToAnyPublisher()
                    case .failure(let error):
                        return Just(Result<Location, Error>.failure(error))
                            .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Equatable

public struct Location: Equatable, Identifiable {
    public let id: UUID = UUID()
    
    public let physical: CLLocation
    public let city: String
    public let state: String
    public let neighborhood: String
    
    init(location physical: CLLocation, city: String, state: String, neighborhood: String = "") {
        self.physical = physical
        self.city = city
        self.state = state
        self.neighborhood = neighborhood
    }
}

public func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.physical == rhs.physical
}

private extension Array where Element: CLPlacemark {
    func location(from physical: CLLocation) -> Result<Location, Error> {
        guard
            let placemark = self.first,
            let city = placemark.locality,
            let state = placemark.administrativeArea
        else { return .failure(LocationError.noData) }
        
        let location = Location(location: physical, city: city, state: state)
        return .success(location)
    }
}
