//
//  Forecast+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

public class Forecast: NSManagedObject {
    @NSManaged var highTemp: Double
    @NSManaged var lowTemp: Double
    @NSManaged var summary: String?
    @NSManaged var icon: String
    @NSManaged var timestamp: Date
    @NSManaged var isHourly: Bool
    
    private enum WrapperKeys: String, CodingKey {
        case hourly
        case daily
    }
    
    private enum DataKeys: String, CodingKey {
        case data
    }
    
    private struct Hourly: Codable {
        enum CodingKeys: String, CodingKey {
            case timestamp = "time"
            case summary
            case icon
            case temperature
        }
        
        let timestamp: Double
        let summary: String
        let icon: String
        let temperature: Double
    }
    
    private struct Daily: Codable {
        enum CodingKeys: String, CodingKey {
            case timestamp = "time"
            case summary
            case icon
            case max = "temperatureMax"
            case min = "temperatureMin"
        }
        
        let timestamp: Double
        let summary: String
        let icon: String
        let max: Double
        let min: Double
    }
}

extension Forecast {
    class func forecasts(from decoder: Decoder) throws -> [Forecast] {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        
        let wrapper = try decoder.container(keyedBy: WrapperKeys.self)
        
        let hourly = try wrapper.nestedContainer(keyedBy: DataKeys.self, forKey: .hourly)
        let hourlyObjs = try hourly.decode([Hourly].self, forKey: .data)
        let hourlyForecasts = hourlyObjs.compactMap { (obj) -> Forecast? in
            return hourlyForecast(with: obj, in: context)
        }
        
        let daily = try wrapper.nestedContainer(keyedBy: DataKeys.self, forKey: .daily)
        let dailyObjs = try daily.decode([Daily].self, forKey: .data)
        let dailyForecasts = dailyObjs.compactMap { (obj) -> Forecast? in
            return dayForecast(with: obj, in: context)
        }
        
        let forecasts = dailyForecasts + hourlyForecasts
        
        return forecasts
    }
    
    private class func hourlyForecast(with obj: Hourly, in context: NSManagedObjectContext) -> Forecast? {
        guard let forecast = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context) as? Forecast else {
            return nil
        }
        
        forecast.isHourly = true
        
        forecast.summary = obj.summary
        forecast.icon = obj.icon
        
        forecast.highTemp = obj.temperature
        forecast.lowTemp = obj.temperature
        
        forecast.timestamp = Date(timeIntervalSince1970: obj.timestamp)
        
        return forecast
    }
    
    private class func dayForecast(with obj: Daily, in context: NSManagedObjectContext) -> Forecast? {
        guard let forecast = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context) as? Forecast else {
            return nil
        }
        
        forecast.isHourly = false
    
        forecast.summary = obj.summary
        forecast.icon = obj.icon
        
        forecast.highTemp = obj.max
        forecast.lowTemp = obj.min
        
        forecast.timestamp = Date(timeIntervalSince1970: obj.timestamp)
        
        return forecast
    }
}
