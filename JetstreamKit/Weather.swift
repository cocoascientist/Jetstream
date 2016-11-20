//
//  Weather.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public struct Weather {
    public let location: Location
    public let conditions: Conditions
    public let forecast: [Forecast]
}

extension Weather {
    init?(json: JSON, location: Location) {
        guard
            let forecasts = Forecast.forecasts(from: json),
            let conditions = Conditions(json: json)
        else {
            return nil
        }
        
        self.conditions = conditions
        self.forecast = forecasts
        self.location = location
    }
}
