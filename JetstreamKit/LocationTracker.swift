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
    var locationChangeEvent: AnyPublisher<Location, Never> {
        return _locationChangeEvent
    }
    
    private var _locationChangeEvent: AnyPublisher<Location, Never> {
        return _currentLocation
            .compactMap { (current) -> Location? in
                guard let current = current else { return nil }
                return Location(location: current, city: "", state: "", neighborhood: "")
            }
            .removeDuplicates(by: { (lhs, rhs) -> Bool in
                return lhs.physical.distance(from: rhs.physical) > 10
            })
            .eraseToAnyPublisher()
    }
    
    private let _locationErrorEvent = PassthroughSubject<LocationError, Never>()
    
    private var lastLocation: Result<Location, Error> = .failure(LocationError.noData)
    private let _currentLocation  = CurrentValueSubject<CLLocation?, Never>.init(nil)
    
    private let locationManager: CLLocationManager
    
    private var disposables: [AnyCancellable] = []
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        
        super.init()
        
        locationManager.delegate = self
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

    private func shouldUpdate(with location: CLLocation) -> Bool {
        switch lastLocation {
        case .success(let loc):
            return location.distance(from: loc.physical) > 100
        case .failure:
            return true
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationTracker: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _locationErrorEvent.send(LocationError.other(error))
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        _currentLocation.send(location)
    }
}

// MARK: - Equatable

public struct Location: Equatable, Identifiable {
    public let id: UUID = UUID()
    
    public let physical: CLLocation
    public let city: String
    public let state: String
    public let neighborhood: String
    
    init(location physical: CLLocation, city: String, state: String, neighborhood: String) {
        self.physical = physical
        self.city = city
        self.state = state
        self.neighborhood = neighborhood
    }
}

public func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.physical == rhs.physical
}

