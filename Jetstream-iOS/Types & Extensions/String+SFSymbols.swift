//
//  String+WeatherIcons.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

extension String {
    
    public var weatherSymbol: String {
        switch self {
            
        // forecast.io API > SF Symbols
            
        case "clear-day":
            return "sun.max"
        case "clear-night":
            return "moon.stars"
        case "rain":
            return "cloud.rain"
        case "snow":
            return "snow"
        case "sleet":
            return "cloud.sleet"
        case "wind":
            return "wind"
        case "fog":
            return "cloud.fog"
        case "cloudy":
            return "cloud"
        case "partly-cloudy-day":
            return "cloud.sun"
        case "partly-cloudy-night":
            return "cloud.moon"
            
        default:
            return self
        }
    }
}
