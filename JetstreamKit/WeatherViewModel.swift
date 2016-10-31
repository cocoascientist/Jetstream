//
//  WeatherViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public struct WeatherViewModel {
    private let weather: Weather
    
    public init(weather: Weather) {
        self.weather = weather
    }
    
    public var cityName: String {
        let city = weather.location.city
        let state = weather.location.state
        return "\(city), \(state)"
    }
    
    public var currentConditions: String {
        let symbol = self.weather.conditions.icon.weatherSymbol
        let conditions = self.weather.conditions.summary
        return "\(symbol) \(conditions)"
    }
    
    public var currentTemperature: String {
        let temp = NSNumber(value: self.weather.conditions.temperature)
        let currentTemp = self.numberFormatter.string(from: temp) ?? "XX"
        return "\(currentTemp)°"
    }
    
    public var temperatureRange: String {
        if let today = self.weather.forecast.first {
            let min = String(format: "%.1f", today.range.min)
            let max = String(format: "%.1f", today.range.max)
            return "\(max)°\u{FF0F} \(min)°"
        }
        
        return ""
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
}
