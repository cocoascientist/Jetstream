//
//  String+WeatherIcons.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

extension String {
//    @"01d" : @"weather-clear",
//    @"02d" : @"weather-few",
//    @"03d" : @"weather-few",
//    @"04d" : @"weather-broken",
//    @"09d" : @"weather-shower",
//    @"10d" : @"weather-rain",
//    @"11d" : @"weather-tstorm",
//    @"13d" : @"weather-snow",
//    @"50d" : @"weather-mist",
//    @"01n" : @"weather-moon",
//    @"02n" : @"weather-few-night",
//    @"03n" : @"weather-few-night",
//    @"04n" : @"weather-broken",
//    @"09n" : @"weather-shower",
//    @"10n" : @"weather-rain-night",
//    @"11n" : @"weather-tstorm",
//    @"13n" : @"weather-snow",
//    @"50n" : @"weather-mist",
    
    func symbolForCurrentWeather() -> String {
        switch self {
        case "01d": // day-clear
            return "\u{f00d}"
        case "01n": // night-clear
            return "\u{f02e}"
        case "02d": // day-few-clouds
            return "\u{f00c}"
        case "03d": // day-partly-cloudy
            return "\u{f002}"
        case "04d": // day-cloudy
            return "\u{f013}"
        case "04n": // night-cloudy
            return "\u{f031}"
        case "09d": // day-showers
            return "\u{f01a}"
        case "10d": // day-rain
            return "\u{f019}"
        case "13d": // day-snow
            return "\u{f01b}"
        case "13n": // night-snow
            return "\u{f01b}"
        default:
            return self
        }
    }
}