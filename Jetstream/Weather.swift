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
    
    init(location: Location, conditions: Conditions) {
        self.location = location
        self.conditions = conditions
    }
}