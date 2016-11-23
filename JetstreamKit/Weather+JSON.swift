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
    convenience init?(json: JSON, location: Location, context: NSManagedObjectContext) {
        guard let conditions = Conditions.conditions(with: json, in: context) else {
            return nil
        }
        
        guard
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double
        else {
            return nil
        }
        
        self.init(entity: Weather.entity(), insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
        self.city = location.city
        self.state = location.state
        
        self.conditions = conditions
        
        self.forecast = forecasts(with: json, in: context)
    }
    
    func update(with json: JSON, and location: Location) {
        self.latitude = location.physical.coordinate.latitude
        self.longitude = location.physical.coordinate.longitude
        self.city = location.city
        self.state = location.state
        
        self.conditions?.update(with: json)
        self.forecast = forecasts(with: json, in: managedObjectContext)
    }
    
    fileprivate func forecasts(with json: JSON, in context: NSManagedObjectContext?) -> NSOrderedSet {
        guard let context = context else { return NSOrderedSet() }
        
        let forecasts = Forecast.forecasts(with: json, in: context).sorted { (first, second) -> Bool in
            return first.timestamp!.timeIntervalSince1970 < second.timestamp!.timeIntervalSince1970
        }
        
        let trimmed = Array(forecasts[0...2])
        
        return NSOrderedSet(array: trimmed)
    }
}
