//
//  Conditions+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

extension Conditions {
    class func conditions(with json: JSON, in context: NSManagedObjectContext) -> Conditions? {
        let conditions = Conditions(entity: Conditions.entity(), insertInto: context)
        conditions.update(with: json)
        
        return conditions
    }
    
    func update(with json: JSON) {
        guard
            let currently = json["currently"] as? JSON,
            let daily = json["daily"] as? JSON,
            let summary = currently["summary"] as? String,
            let details = daily["summary"] as? String,
            let icon = currently["icon"] as? String,
            let temperature = currently["temperature"] as? Double,
            let timestamp = currently["time"] as? TimeInterval,
            
            let windSpeed = currently["windSpeed"] as? Double,
            let windBearing = currently["windBearing"] as? Int16,
            let humidity = currently["humidity"] as? Double,
            let dewPoint = currently["dewPoint"] as? Double,
            let apparentTemperature = currently["apparentTemperature"] as? Double,
            
            let cloudCover = currently["cloudCover"] as? Double,
            let visibility = currently["visibility"] as? Double,
            
            let data = daily["data"] as? [JSON],
            let today = data.first,
            let sunrise = today["sunriseTime"] as? TimeInterval,
            let sunset = today["sunsetTime"] as? TimeInterval
        
        else { return }
        
        self.icon = icon
        self.summary = summary
        self.details = details
        
        self.temperature = temperature
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.humidity = humidity
        self.dewPoint = dewPoint
        
        self.sunset = NSDate(timeIntervalSince1970: sunset)
        self.sunrise = NSDate(timeIntervalSince1970: sunrise)
        
        self.cloudCover = cloudCover
        self.visibility = visibility
        
        self.apparentTemperature = apparentTemperature
    }
}
