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
            
        // forecast.io API
            
        case "clear-day":
            return "\u{f00d}"
        case "clear-night":
            return "\u{f02e}"
        case "rain":
            return "\u{f019}"
        case "snow":
            return "\u{f01b}"
        case "sleet":
            return "\u{f0b5}"
        case "wind":
            return "\u{f011}"
        case "fog":
            return "\u{f014}"
        case "cloudy":
            return "\u{f013}"
        case "partly-cloudy-day":
            return "\u{f00c}"
        case "partly-cloudy-night":
            return "\u{f083}"
            
        default:
            return self
        }
    }
}
