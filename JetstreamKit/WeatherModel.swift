//
//  WeatherModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

public typealias CurrentForecast = Result<[Forecast]>
public typealias CurrentWeather = Result<Weather>

public extension NSNotification.Name {
    static var forecastDidUpdate = NSNotification.Name.init("ForecastDidUpdate")
    static var conditionsDidUpdate = NSNotification.Name.init("ConditionsDidUpdate")
    static var weatherModelDidReceiveError = NSNotification.Name.init("WeatherModelDidReceiveError")
}

public enum WeatherModelError: Error {
    case noData
    case other(NSError)
}

extension WeatherModelError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .noData:
            return "No response data"
        case .other(let error):
            return "\(error)"
        }
    }
}

public class WeatherModel {
    
    let networkController: NetworkController
    
    private var weather: Weather? {
        didSet {
            NotificationCenter.default.post(name: .forecastDidUpdate, object: nil)
            NotificationCenter.default.post(name: .conditionsDidUpdate, object: nil)
        }
    }
    private let locationTracker = LocationTracker()
    
    public init(networkController: NetworkController = NetworkController()) {
        
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
    
    public var currentForecast: CurrentForecast {
        if let forecast = self.weather?.forecast {
            guard let forecastObjs = forecast.allObjects as? [Forecast] else { fatalError() }
            return success(forecastObjs)
        }
        
        return failure(WeatherModelError.noData)
    }
    
    public var currentWeather: CurrentWeather {
        if let weather = self.weather {
            return success(weather)
        }
        
        return failure(WeatherModelError.noData)
    }
    
    // MARK: - Private
    
    private func updateForecast(_ location: Location) -> Void {
        let request = ForecastAPI.forecast(location.physical).request
        let result: TaskResult = {(result) -> Void in
            let jsonResult = result.flatMap(JSONResultFromData)
            
            switch jsonResult {
            case .success(let json):
                let context = CoreDataManager.sharedManager.managedObjectContext!
                let weather = Weather.weather(with: json, at: location, in: context)
                
                self.weather = weather
            case .failure(let reason):
                self.postErrorNotification(reason)
            }
        }
        
        networkController.startRequest(request, result: result)
    }
    
    private func postErrorNotification(_ error: Error) -> Void {
//        switch error {
//        case .Other(let error):
//            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error])
//        default:
//            NSNotificationCenter.defaultCenter().postNotificationName(WeatherModelDidReceiveErrorNotification, object: nil, userInfo: ["Error": error.debugDescription])
//        }
        
    }
}
