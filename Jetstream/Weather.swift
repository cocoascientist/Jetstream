//
//  Weather.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Weather {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Weather {
    static func weatherFromJSON(json: JSON) -> Weather? {
        if let name = json["name"] as? String {
            let weather = Weather(name: name)
            return weather
        }
        
        return nil
    }
}