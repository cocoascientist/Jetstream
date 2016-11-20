//
//  Forecast.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public typealias TemperatureRange = (min: Double, max: Double)

public struct Forecast {
    public let timestamp: TimeInterval
    public let summary: String
    public let icon: String
    public let range: TemperatureRange
}

extension Forecast {
    
    init?(json: JSON) {
        guard
            let timestamp = json["time"] as? TimeInterval,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let min = json["temperatureMin"] as? Double,
            let max = json["temperatureMax"] as? Double
        else {
            return nil
        }
        
        self.timestamp = timestamp
        self.summary = summary
        self.icon = icon
        
        let range = TemperatureRange(min: min, max: max)
        self.range = range
    }
    
    public static func forecasts(from json: JSON) -> [Forecast]? {
        guard
            let daily = json["daily"] as? JSON,
            let data = daily["data"] as? [JSON]
        else {
            return nil
        }
        
        return data.flatMap(Forecast.init)
    }
    
    public var date: Date {
        return Date(timeIntervalSince1970: self.timestamp)
    }
}
