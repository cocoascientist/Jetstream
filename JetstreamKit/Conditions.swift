//
//  Conditions.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public struct Conditions {
    public let summary: String
    public let icon: String
    public let temperature: Double
    public let time: TimeInterval
    
    public let windSpeed: Double
    public let windBearing: Int
    
    public let humidity: Double
}

extension Conditions {
    
    init?(json: JSON) {
        guard
            let json = json["currently"] as? JSON,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let temperature = json["temperature"] as? Double,
            let time = json["time"] as? TimeInterval,
            let windSpeed = json["windSpeed"] as? Double,
            let windBearing = json["windBearing"] as? Int,
            let humidity = json["humidity"] as? Double
        else {
            return nil
        }
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.time = time
        
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        
        self.humidity = humidity
    }
}
