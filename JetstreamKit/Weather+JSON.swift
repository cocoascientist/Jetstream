//
//  Weather+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

extension Weather {
    class func weather(with json: JSON, at location: Location, in context: NSManagedObjectContext) -> Weather? {
        guard let conditions = Conditions.conditions(with: json, in: context) else {
            return nil
        }
        
        guard
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double
        else {
            return nil
        }
        
        guard let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: context) as? Weather else {
            return nil
        }
        
        weather.latitude = latitude
        weather.longitude = longitude
        
        weather.conditions = conditions
        
        let forecasts = Forecast.forecasts(with: json, in: context)
        weather.forecast = NSSet(array: forecasts)
        
        return weather
    }
}
