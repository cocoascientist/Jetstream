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

enum WeatherModelError: ErrorProtocol {
    case noData
    case other(NSError)
}

extension WeatherModelError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .noData:
            return "No response data"
        case .other(let error):
            return "\(error)"
        }
    }
}

class WeatherModel {
    
    let networkController: NetworkController
    
    private var weather: Weather? {
        didSet {
            NotificationCenter.default().post(name: Notification.Name(rawValue: ForecastDidUpdateNotification), object: nil)
            NotificationCenter.default().post(name: Notification.Name(rawValue: ConditionsDidUpdateNotification), object: nil)
        }
    }
    private let locationTracker = LocationTracker()
    
    init(networkController: NetworkController = NetworkController()) {
        
        self.networkController = networkController
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let loc):
                self.updateForecast(loc)
            case .failure(let error):
                self.postErrorNotification(error)
            }
        }
    }
    
    var currentForecast: CurrentForecast {
        if let forecast = self.weather?.forecast {
            return success(forecast)
        }
        
        return failure(WeatherModelError.noData)
    }
    
    var currentWeather: CurrentWeather {
        if let weather = self.weather {
            return success(weather)
        }
        
        return failure(WeatherModelError.noData)
    }
    
    // MARK: - Private
    
    private func updateForecast(_ location: Location) -> Void {
        let request = ForecastAPI.forecast(location.physical).request()
        let result: TaskResult = {(result) -> Void in
            let jsonResult = result.flatMap(JSONResultFromData)
            
            switch jsonResult {
            case .success(let json):
                self.weather = Weather(json: json, location: location)
            case .failure(let reason):
                self.postErrorNotification(reason)
            }
        }
        
        networkController.startRequest(request, result: result)
    }
    
    private func postErrorNotification(_ error: ErrorProtocol) -> Void {
//        switch error {
//        case .Other(let error):
//            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error])
//        default:
//            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error.debugDescription])
//        }
        
    }
}
