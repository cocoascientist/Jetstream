//
//  Conditions.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Conditions {
    let summary: String
    let icon: String
    let temperature: Double
    let time: TimeInterval
    
    init(summary: String, icon: String, temperature: Double, time: TimeInterval) {
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.time = time
    }
}

extension Conditions {
    static func conditionsFromJSON(_ json: JSON) -> Conditions? {
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
