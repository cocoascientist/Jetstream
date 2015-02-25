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

let ForecastDidUpdateNotification = "ForecastDidUpdateNotification"
let ConditionsDidUpdateNotification = "ConditionsDidUpdateNotification"
let WeatherModelDidReceiveErrorNotification = "WeatherModelDidReceiveErrorNotification"

class WeatherModel {
    
    private var weather: Weather? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ForecastDidUpdateNotification, object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(ConditionsDidUpdateNotification, object: nil)
        }
    }
    private let locationTracker = LocationTracker()
    
    init() {
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .Success(let box):
                self.updateForecast(box.unbox)
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
        }
    }
    
    var currentForecast: CurrentForecast {
        if let forecast = self.weather?.forecast {
            return success(forecast)
        }
        
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
                    if let forecast = Forecast.forecastsFromJSON(json.unbox) {
                        self.weather = Weather(location: location, conditions: conditions, forecast: forecast)
                    }
                }
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
        }
        
        NetworkController.task(request, result: result).resume()
    }
    
    private func postErrorNotification(reason: Reason) -> Void {
        switch reason {
        case .Other(let error):
            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error])
        default:
            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": reason.description])
        }
        
    }
}