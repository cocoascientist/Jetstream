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
            let icon = currently["icon"] as? String
//            let temperature = currently["temperature"] as? Double,
//            let time = currently["time"] as? TimeInterval,
//            let windSpeed = currently["windSpeed"] as? Double,
//            let windBearing = currently["windBearing"] as? Int,
//            let humidity = currently["humidity"] as? Double
        else {
            return nil
        }
        
        guard let conditions = NSEntityDescription.insertNewObject(forEntityName: "Conditions", into: context) as? Conditions else {
            return nil
        }
        
        conditions.summary = summary
        conditions.icon = icon
        
        return conditions
    }
}
