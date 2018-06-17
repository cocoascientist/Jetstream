//
//  Forecast+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

extension Forecast {
    class func forecasts(with json: JSON, in context: NSManagedObjectContext) -> [Forecast] {
        guard let daily = json["daily"] as? JSON else { return [] }
        guard let hourly = json["hourly"] as? JSON else { return [] }
        
        guard let dailyData = daily["data"] as? [JSON] else { return [] }
        guard let hourlyData = hourly["data"] as? [JSON] else { return [] }
        
        let weeklyForecasts = dailyData.compactMap { (obj) -> Forecast? in
            return dayForecast(with: obj, in: context)
        }
        
        let hourlyForecasts = hourlyData.compactMap { (obj) -> Forecast? in
            return hourlyForecast(with: obj, in: context)
        }
        
        let forecasts = weeklyForecasts + hourlyForecasts
        
        return forecasts
    }
    
    class func hourlyForecast(with json: JSON, in context: NSManagedObjectContext) -> Forecast? {
        guard
            let timestamp = json["time"] as? TimeInterval,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let highTemp = json["temperature"] as? Double
//            let lowTemp = json["precipProbability"] as? Double
        else {
            return nil
        }
        
        guard let forecast = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context) as? Forecast else {
            return nil
        }
        
        forecast.isHourly = true
        
        forecast.summary = summary
        forecast.icon = icon
        
        forecast.highTemp = highTemp
        forecast.lowTemp = highTemp
        
        forecast.timestamp = Date(timeIntervalSince1970: timestamp)
        
        return forecast
    }
    
    class func dayForecast(with json: JSON, in context: NSManagedObjectContext) -> Forecast? {
        guard
            let timestamp = json["time"] as? TimeInterval,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let highTemp = json["temperatureMax"] as? Double,
            let lowTemp = json["temperatureMin"] as? Double
        else {
            return nil
        }
        
        guard let forecast = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context) as? Forecast else {
            return nil
        }
        
        forecast.isHourly = false
    
        forecast.summary = summary
        forecast.icon = icon
        
        forecast.highTemp = highTemp
        forecast.lowTemp = lowTemp
        
        forecast.timestamp = Date(timeIntervalSince1970: timestamp)
        
        return forecast
    }
}
