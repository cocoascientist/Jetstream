//
//  Weather.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Weather {
    let location: Location
    let conditions: Conditions
    let forecast: [Forecast]
    
    init(location: Location, conditions: Conditions, forecast: [Forecast]) {
        self.location = location
        self.conditions = conditions
        self.forecast = forecast
    }
}