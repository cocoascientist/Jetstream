//
//  WeatherViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct WeatherViewModel {
    private let weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    var cityName: String {
        let city = weather.location.city
        let state = weather.location.state
        return "\(city), \(state)"
    }
    
    var currentConditions: String {
        let symbol = self.weather.conditions.icon.symbolForCurrentWeather()
        let conditions = self.weather.conditions.summary
        return "\(symbol) \(conditions)"
    }
    
    var currentTemperature: String {
        let currentTemp = self.numberFormatter.stringFromNumber(self.weather.conditions.temperature)
        return "\(currentTemp!)°"
    }
    
    private var numberFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 0
        return formatter
    }
}