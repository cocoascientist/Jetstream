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

public class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    private var lastResult: LocationResult = .Failure(.NoData)
    private var observers: [Observer] = []
    
    var currentLocation: LocationResult {
        return self.lastResult
    }
    
    override init() {
        super.init()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - Public
    
    func addLocationChangeObserver(observer: Observer) -> Void {
        observers.append(observer)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let result = LocationResult.Failure(Reason.Other(error))
        self.publishChangeWithResult(result)
        self.lastResult = result
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if shouldUpdateWithLocation(currentLocation) {
                
                let completion: ([CLPlacemark]?, NSError?) -> () = { (placemarks, error) in
                    if let placemark = placemarks?.first,
                        let city = placemark.locality,
                        let state = placemark.administrativeArea
                    {
                        if self.shouldUpdateWithLocation(currentLocation) {
                            let location = Location(location: currentLocation, city: city, state: state)
                            
                            let result = LocationResult.Success(location)
                            self.publishChangeWithResult(result)
                            self.lastResult = result
                            
                            print(result)
                        }
                        
                    }
                    else if let error = error {
                        let result = LocationResult.Failure(Reason.Other(error))
                        self.publishChangeWithResult(result)
                        self.lastResult = result
                    }
                }
                
                CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: completion)
            }
            
            // location hasn't changed significantly
        }
    }
    
    private func didReverseGecode(location: CLLocation, withPlacemarks placemarks: [CLPlacemark]?) {
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
    
    private func publishChangeWithResult(result: LocationResult) {
        if self.shouldUpdateWithResult(result) {
            observers.forEach { observer in
                observer(location: result)
            }
        }
    }
    
    private func shouldUpdateWithLocation(location: CLLocation) -> Bool {
        switch lastResult {
        case .Success(let loc):
            return location.distanceFromLocation(loc.physical) > 100
        case .Failure:
            return true
        }
    }
    
    private func shouldUpdateWithResult(result: LocationResult) -> Bool {
        switch lastResult {
        case .Success(let loc):
            let location = loc.physical
            return self.shouldUpdateWithLocation(location)
        case .Failure:
            return true
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
