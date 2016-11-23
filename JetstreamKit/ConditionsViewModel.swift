//
//  ConditionsViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/21/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public struct ConditionsViewModel {
    private let weather: Weather
    
    public init(weather: Weather) {
        self.weather = weather
    }
    
    public var cityName: String {
        let city = weather.city!
        let state = weather.state!
        return "\(city), \(state)"
    }
    
    public var weatherIcon: String {
        return self.weather.conditions?.icon?.weatherSymbol ?? ""
    }
    
    public var summary: String {
        return weather.conditions!.summary ?? ""
    }
    
    var currentTemperature: String {
        let value = self.weather.conditions?.temperature ?? 0.0
        let temp = NSNumber(value: value)
        let currentTemp = self.numberFormatter.string(from: temp) ?? "XX"
        return "\(currentTemp)°"
    }
    
    var temperatureRange: String {
//        if let today = self.weather.forecast?.first {
//            let min = String(format: "%.1f", today.range.min)
//            let max = String(format: "%.1f", today.range.max)
//            return "\(max)°\u{FF0F} \(min)°"
//        }
        
        return ""
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
}
