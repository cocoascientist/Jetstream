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

enum WeatherModelError: ErrorType {
    case NoData
    case Other(NSError)
}

extension WeatherModelError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .NoData:
            return "No response data"
        case .Other(let error):
            return "\(error)"
        }
    }
}

class WeatherModel {
    
    let networkController: NetworkController
    
    private var weather: Weather? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ForecastDidUpdateNotification, object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(ConditionsDidUpdateNotification, object: nil)
        }
    }
    private let locationTracker = LocationTracker()
    
    init(networkController: NetworkController = NetworkController()) {
        
        self.networkController = networkController
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .Success(let loc):
                self.updateForecast(loc)
            case .Failure(let error):
                self.postErrorNotification(error)
            }
        }
    }
    
    var currentForecast: CurrentForecast {
        if let forecast = self.weather?.forecast {
            return success(forecast)
        }
        
        return failure(WeatherModelError.NoData)
    }
    
    var currentWeather: CurrentWeather {
        if let weather = self.weather {
            return success(weather)
        }
        
        return failure(WeatherModelError.NoData)
    }
    
    // MARK: - Private
    
    private func updateForecast(location: Location) -> Void {
        let request = ForecastAPI.Forecast(location.physical).request()
        let result: TaskResult = {(result) -> Void in
            let jsonResult = result.flatMap(JSONResultFromData)
            
            switch jsonResult {
            case .Success(let json):
                if let conditions = Conditions.conditionsFromJSON(json) {
                    if let forecast = Forecast.forecastsFromJSON(json) {
                        self.weather = Weather(location: location, conditions: conditions, forecast: forecast)
                    }
                }
            case .Failure(let reason):
                self.postErrorNotification(reason)
            }
        }
        
        networkController.startRequest(request, result: result)
    }
    
    private func postErrorNotification(error: ErrorType) -> Void {
//        switch error {
//        case .Other(let error):
//            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error])
//        default:
//            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error.debugDescription])
//        }
        
    }
}