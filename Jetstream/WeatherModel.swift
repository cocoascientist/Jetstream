//
//  WeatherModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

typealias CurrentForecast = Result<[Forecast]>
typealias CurrentWeather = Result<Weather>

let WeatherDidUpdateNotification = "WeatherDidUpdateNotification"
let ForecastDidUpdateNotification = "ForecastDidUpdateNotification"
let ConditionsDidUpdateNotification = "ConditionsDidUpdateNotification"

let ConditionsModelDidReceiveErrorNotification = "ConditionsModelDidReceiveErrorNotification"

class WeatherModel {
    
    private var weather: Weather? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ConditionsDidUpdateNotification, object: nil)
        }
    }
    private let locationTracker = LocationTracker()
    
    init() {
        self.locationTracker.addLocationChangeObserver { (location) -> () in
            self.updateForecast(location)
        }
    }
    
    var currentForecast: CurrentForecast {
        // TODO: remove
        return failure(.NoData)
    }
    
    var currentWeather: CurrentWeather {
        if let weather = self.weather {
            return success(weather)
        }
        
        return failure(.NoData)
    }
    
    // MARK: - Private
    
    private func updateForecast(location: Location) -> Void {
        let request = ForecastAPI.Forecast(location.physical).request()
        let result: TaskResult = {(result) -> Void in
            let jsonResult = toJSONResult(result)
            switch jsonResult {
            case .Success(let json):
                if let conditions = Conditions.conditionsFromJSON(json.unbox) {
                    self.weather = Weather(location: location, conditions: conditions)
                }
                if let forecast = Forecast.forecastFromJSON(json.unbox) {
                    println("forecast!")
                }
                
            case .Failure(let reason):
                println("error: \(reason.description)")
            }
        }
        
        NetworkController.task(request, result: result).resume()
    }
    
    private func postErrorNotification(reason: Reason) -> Void {
        let description = reason.description
        NSNotificationCenter.defaultCenter().postNotificationName(ConditionsModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": description])
    }
}