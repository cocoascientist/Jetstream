//
//  WeatherStore.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import Combine

public final class WeatherStore {
    public lazy var initializedDataStoreEvent: Future<Void, Error> = {
        return Future<Void, Error>.init { [weak self] (observer) in
            self?.dataController.persistentStoreContainer
                .loadPersistentStores { (description, error) in
                    if let error = error {
                        observer(.failure(error))
                    } else {
                        observer(.success(()))
                    }
                }
        }
    }()
    
    public var weatherDidChange: AnyPublisher<Void, Never> {
        return _weatherDidChange.eraseToAnyPublisher()
    }
    private let _weatherDidChange = PassthroughSubject<Void, Never>()
    
    private let dataController: CoreDataController
    private let locationTracker = LocationTracker()
    
    private var cancelables: [AnyCancellable] = []
    
    public init(dataController: CoreDataController = CoreDataController()) {
        self.dataController = dataController
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
    }
    
    public var managedObjectContext: NSManagedObjectContext {
        return dataController.persistentStoreContainer.viewContext
    }
    
    public var backgroundManagedObjectContext: NSManagedObjectContext {
        return dataController.persistentStoreContainer.newBackgroundContext()
    }
}

public enum WeatherStoreUpdateType {
    case noData
    case newData
}

public enum WeatherStoreError: Error {
    case noData
    case other(NSError)
}

extension WeatherStoreError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .noData:
            return "No response data"
        case .other(let error):
            return "\(error)"
        }
    }
}
