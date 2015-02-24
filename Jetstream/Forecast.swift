//
//  Forecast.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias TemperatureRange = (min: Double, max: Double)

struct Forecast {
    let timestamp: NSTimeInterval
    let summary: String
    let icon: String
    
    let range: TemperatureRange
    
    init(timestamp: NSTimeInterval, summary: String, icon: String, range: TemperatureRange) {
        self.timestamp = timestamp
        self.summary = summary
        self.icon = icon
        self.range = range
    }
    
    var date: NSDate {
        get {
            return NSDate(timeIntervalSince1970: self.timestamp)
        }
    }
}

extension Forecast {
    static func forecastFromJSON(json: JSON) -> Forecast? {
        if let timestamp = json["time"] as? NSTimeInterval,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let min = json["temperatureMin"] as? Double,
            let max = json["temperatureMax"] as? Double {
                
                let range = TemperatureRange(min: min, max: max)
                return Forecast(timestamp: timestamp, summary: summary, icon: icon, range: range)
        }
        
        return nil
    }
    
    static func forecastsFromJSON(json: JSON) -> [Forecast]? {
        var forecasts: [Forecast]? = nil
        if let daily = json["daily"] as? JSON,
            let data = daily["data"] as? [JSON] {
            forecasts = []
            for obj in data {
                if let forecast = self.forecastFromJSON(obj) {
                    forecasts?.append(forecast)
                }
            }
        }
        
        return forecasts
    }
}