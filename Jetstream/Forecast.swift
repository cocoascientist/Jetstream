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
    let timestamp: TimeInterval
    let summary: String
    let icon: String
    
    let range: TemperatureRange
    
    init(timestamp: TimeInterval, summary: String, icon: String, range: TemperatureRange) {
        self.timestamp = timestamp
        self.summary = summary
        self.icon = icon
        self.range = range
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: self.timestamp)
    }
}

extension Forecast {
    static func forecastFromJSON(_ json: JSON) -> Forecast? {
        guard
            let timestamp = json["time"] as? TimeInterval,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let min = json["temperatureMin"] as? Double,
            let max = json["temperatureMax"] as? Double
        else {
            return nil
        }
        
        let range = TemperatureRange(min: min, max: max)
        return Forecast(timestamp: timestamp, summary: summary, icon: icon, range: range)
    }
    
    static func forecastsFromJSON(_ json: JSON) -> [Forecast]? {
        guard
            let daily = json["daily"] as? JSON,
            let data = daily["data"] as? [JSON]
        else {
            return nil
        }
        
        return data.flatMap(forecastFromJSON)
    }
}
