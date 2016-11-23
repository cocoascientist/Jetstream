//
//  WeatherModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

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

public class WeatherModel: NSObject {
    
    let networkController: NetworkController
    let dataController: CoreDataController
    
//    private var weather: Weather? {
//        didSet {
//            NotificationCenter.default.post(name: .forecastDidUpdate, object: nil)
//            NotificationCenter.default.post(name: .conditionsDidUpdate, object: nil)
//        }
//    }
    private let locationTracker = LocationTracker()
    
    public init(dataController: CoreDataController = CoreDataController(), networkController: NetworkController = NetworkController()) {
        
        self.networkController = networkController
        self.dataController = dataController
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherModel.contextDidChange(notification:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
//    public var currentForecast: CurrentForecast {
//        if let forecast = self.weather?.forecast {
//            guard let forecastObjs = forecast.allObjects as? [Forecast] else { fatalError() }
//            return success(forecastObjs)
//        }
//        
//        return failure(WeatherModelError.noData)
//    }
//    
//    public var currentWeather: CurrentWeather {
//        if let weather = self.weather {
//            return success(weather)
//        }
//        
//        return failure(WeatherModelError.noData)
//    }
    
    public func currentWeather() -> CurrentWeather {
        let context = self.dataController.persistentStoreContainer.viewContext
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            
            guard let weather = results.first else {
                return .failure(WeatherModelError.noData)
            }
            
            return success(weather)
        } catch {
            print("error executing fetch request: \(error)")
            return .failure(WeatherModelError.other(error as NSError))
        }
    }
    
    public func loadInitialModel(completion: @escaping (_ error: Error?) -> ()) {
        dataController.persistentStoreContainer.loadPersistentStores { [unowned self] (description, error) in
            
            print("loaded store: \(description.url!.lastPathComponent)")
            
            self.locationTracker.addLocationChangeObserver(self.updateLocation)
            completion(error)
        }
    }
    
    // MARK: - Private
    
    public func contextDidChange(notification: Notification) {
        print("processing context change notification...")
        
        let context = self.dataController.persistentStoreContainer.viewContext
        context.mergeChanges(fromContextDidSave: notification)
        
        NotificationCenter.default.post(name: .forecastDidUpdate, object: nil)
        NotificationCenter.default.post(name: .conditionsDidUpdate, object: nil)
    }
    
    private func updateLocation(for result: LocationResult) {
        switch result {
        case .success(let location):
                print("sjould update model...")
            self.updateWeatherModel(for: location)
        case .failure(let error):
            self.postErrorNotification(error)
        }
    }
    
    private func updateWeatherModel(for location: Location) -> Void {
        let request = ForecastAPI.forecast(location.physical).request
        let result: TaskResult = {(result) -> Void in
            let jsonResult = result.flatMap(JSONResultFromData)
            
            switch jsonResult {
            case .success(let json):
//                print("json: \(json)")
                self.dataController.persistentStoreContainer.performBackgroundTask({ (context) in
                    
                    let request: NSFetchRequest<Weather> = Weather.fetchRequest()
                    
                    do {
                        let result = try context.fetch(request)
                        
                        print("found \(result.count) results")
                        
                        var weather = result.first
                        
                        if weather != nil {
                            weather?.update(with: json, and: location)
                        }
                        else {
                            weather = Weather(json: json, location: location, context: context)
                        }
                        
                        print("weather: \(weather?.conditions?.summary)")
                        
                        try context.save()
                    }
                    catch {
                        print("error: \(error)")
                    }
                })
            case .failure(let error):
                self.postErrorNotification(error)
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
