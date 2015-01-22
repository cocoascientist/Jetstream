//
//  WeatherModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

typealias CityState = (city: String, state: String)
typealias CurrentWeather = Result<Weather>

let WeatherDidUpdateNotification = "WeatherDidUpdateNotification"

class WeatherModel {
    
    private var weather: Weather?
    private let locationTracker = LocationTracker()
    
    init() {
        self.locationTracker.addLocationChangeObserver { (location) -> () in
            self.updateWeather(location)
        }
    }
    
    func currentWeather() -> CurrentWeather {
        if let weather = self.weather {
            return Result.Success(weather)
        }

        switch self.locationTracker.currentLocation {
            case .Success(let location):
                self.updateWeather(location())
            case .Failure(let reason):
                println("error finding current location")
        }
        
        return Result.Failure(Reason.NoData)
    }
    
    private func updateWeather(location: CLLocation) -> Void {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks.first as? CLPlacemark {
                let citystate = (placemark.locality!, placemark.administrativeArea!)
                self.updateWeather(citystate)
            }
            else {
                println("error geocoding location")
            }
        })
    }
    
    private func updateWeather(citystate: CityState) -> Void {
        let request = OpenWeatherMapAPI.Conditions(citystate.city, citystate.state).request()
        let result: TaskResult = {(result) -> Void in
            switch result {
            case .Success(let data):
                let jsonResult = data().toJSON()
                switch jsonResult {
                case .Success(let json):
                    if let weather = Weather.weatherFromJSON(json()) {
                        self.weather = weather
                        NSNotificationCenter.defaultCenter().postNotificationName(WeatherDidUpdateNotification, object: nil)
                    }
                case .Failure(let reason):
                    println("error: \(reason.description)")
                }
            case .Failure(let reason):
                println("error: \(reason.description)")
            }
        }
        
        NetworkController.task(request, result: result).resume()
    }
}