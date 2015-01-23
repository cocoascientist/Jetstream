//
//  ConditionsViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct ConditionsViewModel {
    private let weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    var cityName: String {
        return self.weather.name
    }
    
    var currentConditions: String {
        let symbol = self.weather.conditions.icon.symbolForCurrentWeather()
        let conditions = self.weather.conditions.description
        return "\(symbol) \(conditions)"
    }
    
    var currentTemperature: String {
        let currentTemp = self.numberFormatter.stringFromNumber(self.weather.temperatures.currentTemp.toFahrenheit())
        return "\(currentTemp!)°"
    }
    
    var temperatureRange: String {
        let minTemp = self.numberFormatter.stringFromNumber(self.weather.temperatures.minTemp.toFahrenheit())
        let maxTemp = self.numberFormatter.stringFromNumber(self.weather.temperatures.maxTemp.toFahrenheit())
        return "\(minTemp!)° / \(maxTemp!)°"
    }
    
    private var numberFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 0
        return formatter
    }
}