//
//  ConditionsViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct ConditionsViewModel {
    private let conditions: Conditions
    
    init(conditions: Conditions) {
        self.conditions = conditions
    }
    
    var cityName: String {
        return "Fix Me"
    }
    
    var currentConditions: String {
        let symbol = self.conditions.icon.symbolForCurrentWeather()
        let conditions = self.conditions.summary
        return "\(symbol) \(conditions)"
    }
    
    var currentTemperature: String {
        let currentTemp = self.numberFormatter.stringFromNumber(self.conditions.temperature)
        return "\(currentTemp!)°"
    }
    
    var temperatureRange: String {
//        let minTemp = self.numberFormatter.stringFromNumber(self.weather.temperatures.minTemp.toFahrenheit())
//        let maxTemp = self.numberFormatter.stringFromNumber(self.weather.temperatures.maxTemp.toFahrenheit())
//        return "\(minTemp!)° / \(maxTemp!)°"
        
        return "Fix Me"
    }
    
    private var numberFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 0
        return formatter
    }
}