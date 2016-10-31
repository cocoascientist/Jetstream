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
    
    public init(summary: String, icon: String, temperature: Double, time: TimeInterval) {
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.time = time
    }
}

extension Conditions {
    public static func conditions(from json: JSON) -> Conditions? {
        guard
            let json = json["currently"] as? JSON,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String,
            let temperature = json["temperature"] as? Double,
            let time = json["time"] as? TimeInterval
        else {
            return nil
        }
        
        return Conditions(summary: summary, icon: icon, temperature: temperature, time: time)
    }
}
