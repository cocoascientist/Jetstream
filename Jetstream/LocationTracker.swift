//
//  LocationTracker.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationChangeObserver = (location: CLLocation) -> ()
typealias LocationResult = Result<CLLocation>

class LocationTracker: NSObject, CLLocationManagerDelegate {
    private var lastLocation: CLLocation? = nil
    private var observers: [LocationChangeObserver] = []
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    var currentLocation: LocationResult {
        if let location = lastLocation {
            return Result.Success(location)
        }
        else {
            return Result.Failure(Reason.NoData)
        }
    }
    
    override init() {
        super.init()
        self.locationManager.startUpdatingLocation()
    }
    
    func addLocationChangeObserver(observer: LocationChangeObserver) -> Void {
        observers.append(observer)
    }
    
    func publishChangeWithLocation(location: CLLocation) {
//        println("updated location: \(location.coordinate.latitude, location.coordinate.longitude)")
        
        for observer in observers {
            observer(location: location)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location manager failed with error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let currentLocation = locations.first as? CLLocation {
            if lastLocation == nil || currentLocation.distanceFromLocation(lastLocation) > 100 {
                lastLocation = currentLocation
                publishChangeWithLocation(currentLocation)
            } else {
//                println("location hasn't changed significantly")
            }
        }
    }
}
