//
//  LocationTracker.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationChangeObserver = (location: Location) -> ()
typealias LocationResult = Result<Location>

class LocationTracker: NSObject, CLLocationManagerDelegate {
    private var lastLocation: Location? = nil
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
            return Result.Success(Box(location))
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
    
    func publishChangeWithLocation(location: Location) {
        observers.map { (observer) -> Void in
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
            if shouldUpdateWithLocation(currentLocation) {
                CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
                    if let placemark = placemarks?.first as? CLPlacemark,
                        let city = placemark.locality,
                        let state = placemark.administrativeArea,
                        let neighborhood = placemark.subLocality {
                            
                            if self.shouldUpdateWithLocation(currentLocation) {
                                let location = Location(location: currentLocation, city: city, state: state, neighborhood: neighborhood)
                                self.lastLocation = location
                                
                                self.publishChangeWithLocation(location)
                            }
                    }
                    else {
                        println("error geocoding location")
                    }
                })
            }
            
            // location hasn't changed significantly
        }
    }
    
    func shouldUpdateWithLocation(location: CLLocation) -> Bool {
        return (lastLocation == nil || location.distanceFromLocation(lastLocation!.physical) > 100)
    }
}
