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
            
        // OpenWeatherMapAPI
            
        case "01d": // .wi-day-sunny
            return "\u{f00d}"
        case "01n": // .wi-night-clear
            return "\u{f02e}"
        case "02d": // .wi-day-sunny-overcast
            return "\u{f00c}"
        case "02n": // night-partly-cloudy
            return "\u{f083}"
        case "03d": // .wi-day-cloudy
            return "\u{f002}"
        case "03n": // .wi-night-cloudy
            return "\u{f031}"
        case "04d": // .wi-cloudy
            return "\u{f013}"
        case "04n": // .wi-cloudy
            return "\u{f013}"
        case "09d": // .wi-day-showers
            return "\u{f009}"
        case "09n": // .wi-night-alt-showers
            return "\u{f029}"
        case "10d": // .wi-rain
            return "\u{f019}"
        case "10n": // .wi-night-alt-rain
            return "\u{f028}"
        case "11d": // .wi-thunderstorm
            return "\u{f01e}"
        case "11n": // .wi-thunderstorm
            return "\u{f01e}"
        case "13d": // .wi-snow
            return "\u{f01b}"
        case "13n": // .wi-snow
            return "\u{f01b}"
        case "50d": // .wi-sprinkle
            return "\u{f01c}"
        case "50n": // .wi-sprinkle
            return "\u{f01c}"
            
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
