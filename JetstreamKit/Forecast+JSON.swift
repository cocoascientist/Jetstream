//
//  Forecast+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

extension Forecast {
    class func forecasts(with json: JSON, in context: NSManagedObjectContext) -> [Forecast] {
        guard let daily = json["daily"] as? JSON else { return [] }
        guard let data = daily["data"] as? [JSON] else { return [] }
        
        let forecasts = data.flatMap { (obj) -> Forecast? in
            return forecast(with: obj, in: context)
        }
        
        return forecasts
    }
    
    class func forecast(with json: JSON, in context: NSManagedObjectContext) -> Forecast? {
        guard
//            let timestamp = json["time"] as? TimeInterval,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String
//            let min = json["temperatureMin"] as? Double,
//            let max = json["temperatureMax"] as? Double
        else {
            return nil
        }
        
        guard let forecast = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context) as? Forecast else {
            return nil
        }
        
        forecast.summary = summary
        forecast.icon = icon
        
        return forecast
    }
}
