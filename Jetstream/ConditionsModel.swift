//
//  ConditionsModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

typealias CityState = (city: String, state: String)
typealias CurrentWeather = Result<Weather>
typealias CurrentForecast = Result<[Forecast]>

let WeatherDidUpdateNotification = "WeatherDidUpdateNotification"
let ForecastDidUpdateNotification = "ForecastDidUpdateNotification"

let ConditionsModelDidReceiveErrorNotification = "ConditionsModelDidReceiveErrorNotification"

class ConditionsModel {
    private var weather: Weather?
    private var forecasts: [Forecast]?
    private let locationTracker = LocationTracker()
    
    init() {
        self.locationTracker.addLocationChangeObserver { (location) -> () in
            self.updateWeather(location)
        }
    }
    
    func currentWeather() -> CurrentWeather {
        if let weather = self.weather {
            return success(weather)
        }

        switch self.locationTracker.currentLocation {
            case .Success(let location):
                self.updateWeather(location.unbox)
            case .Failure(let reason):
                println("error finding current location")
        }
        
        return failure(.NoData)
    }
    
    func currentForecasts() -> CurrentForecast {
        if let forecasts = self.forecasts {
            return success(forecasts)
        }
        
        return failure(.NoData)
    }
    
    private func updateWeather(location: CLLocation) -> Void {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks?.first as? CLPlacemark {
                if let locality = placemark.locality {
                    if let area = placemark.administrativeArea {
                        let citystate = (locality, area)
                        self.updateWeather(citystate)
                        self.updateForecast(citystate)
                    }
                }
            }
            else {
                println("error geocoding location")
            }
        })
    }
    
    private func updateWeather(citystate: CityState) -> Void {
        let request = OpenWeatherMapAPI.Conditions(citystate.city, citystate.state).request()
        let result: TaskResult = {(result) -> Void in
            let jsonResult = self.toJSONResult(result)
            switch jsonResult {
                case .Success(let json):
                    if let weather = Weather.weatherFromJSON(json.unbox) {
                        self.weather = weather
                        NSNotificationCenter.defaultCenter().postNotificationName(WeatherDidUpdateNotification, object: nil)
                    }
                case .Failure(let reason):
                    println("error: \(reason.description)")
            }
        }
        
        NetworkController.task(request, result: result).resume()
    }
    
    private func updateForecast(citystate: CityState) -> Void {
        let request = OpenWeatherMapAPI.Forecast(citystate.city, citystate.state).request()
        let result: TaskResult = {(result) -> Void in
            let jsonResult = self.toJSONResult(result)
            switch jsonResult {
                case .Success(let json):
                    if let forecasts = Forecast.forecastsFromJSON(json.unbox) {
                        self.forecasts = forecasts
                        NSNotificationCenter.defaultCenter().postNotificationName(ForecastDidUpdateNotification, object: nil)
                    }
                case .Failure(let reason):
                    println("error: \(reason.description)")
            }
        }
        
        NetworkController.task(request, result: result).resume()
    }
    
    private func toJSONResult(result: Result<NSData>) -> JSONResult {
        switch result {
            case .Success(let data):
                return data.unbox.toJSON()
            case .Failure(let reason):
                return JSONResult.Failure(reason)
        }
    }
    
    private func postErrorNotification(reason: Reason) -> Void {
        let description = reason.description
        NSNotificationCenter.defaultCenter().postNotificationName(ConditionsModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": description])
    }
}