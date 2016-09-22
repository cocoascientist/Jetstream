//
//  LocationTracker.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

public typealias LocationResult = Result<Location>
public typealias Observer = (location: LocationResult) -> ()

enum LocationError: ErrorProtocol {
    case noData
    case other(NSError)
}

public class LocationTracker: NSObject {
    
    private var lastResult: LocationResult = .failure(LocationError.noData)
    private var observers: [Observer] = []
    
    var currentLocation: LocationResult {
        return self.lastResult
    }
    
    override init() {
        super.init()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - Public
    
    func addLocationChangeObserver(_ observer: Observer) -> Void {
        observers.append(observer)
    }
    
    private func didReverseGecode(_ location: CLLocation, withPlacemarks placemarks: [CLPlacemark]?) {
        //
    }
    
    // MARK: - Private
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    private func publishChangeWithResult(_ result: LocationResult) {
        if self.shouldUpdateWithResult(result) {
            observers.forEach { observer in
                observer(location: result)
            }
        }
    }
    
    private func shouldUpdateWithLocation(_ location: CLLocation) -> Bool {
        switch lastResult {
        case .success(let loc):
            return location.distance(from: loc.physical) > 100
        case .failure:
            return true
        }
    }
    
    private func shouldUpdateWithResult(_ result: LocationResult) -> Bool {
        switch lastResult {
        case .success(let loc):
            let location = loc.physical
            return self.shouldUpdateWithLocation(location)
        case .failure:
            return true
        }
    }
}

extension LocationTracker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        let result = LocationResult.failure(LocationError.other(error))
        self.publishChangeWithResult(result)
        self.lastResult = result
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if shouldUpdateWithLocation(currentLocation) {
                
                let completion: ([CLPlacemark]?, NSError?) -> () = { (placemarks, error) in
                    if let placemark = placemarks?.first,
                        let city = placemark.locality,
                        let state = placemark.administrativeArea {
                        if self.shouldUpdateWithLocation(currentLocation) {
                            let location = Location(location: currentLocation, city: city, state: state)
                            let result = LocationResult.success(location)
                            self.publishChangeWithResult(result)
                            self.lastResult = result
                        }
                    } else {
                        let result = LocationResult.failure(LocationError.noData)
                        self.publishChangeWithResult(result)
                        self.lastResult = result
                    }
                }
                
                CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: completion)
            }
            
            // location hasn't changed significantly
        }
    }
}

public struct Location: Equatable {
    let physical: CLLocation
    let city: String
    let state: String
    
    init(location physical: CLLocation, city: String, state: String) {
        self.physical = physical
        self.city = city
        self.state = state
    }
}

public func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.physical == rhs.physical
}
