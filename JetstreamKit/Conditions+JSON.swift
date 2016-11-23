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
        guard
            let currently = json["currently"] as? JSON,
            let summary = currently["summary"] as? String,
            let icon = currently["icon"] as? String,
            let temperature = currently["temperature"] as? Double,
            let timestamp = currently["time"] as? TimeInterval
//            let windSpeed = currently["windSpeed"] as? Double,
//            let windBearing = currently["windBearing"] as? Int,
//            let humidity = currently["humidity"] as? Double
        else {
            return nil
        }
        
        let conditions = Conditions(entity: Conditions.entity(), insertInto: context)
        
        conditions.summary = summary
        conditions.icon = icon
        conditions.temperature = temperature
        
        conditions.timestamp = NSDate(timeIntervalSince1970: timestamp)
        
        
        return conditions
    }
    
    func update(with json: JSON) {
        guard
            let currently = json["currently"] as? JSON,
            let summary = currently["summary"] as? String,
            let icon = currently["icon"] as? String
        else {
            return
        }
        
        self.summary = summary
        self.icon = icon
    }
}
