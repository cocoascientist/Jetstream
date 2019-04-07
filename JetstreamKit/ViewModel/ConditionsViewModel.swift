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
        let city = weather.city ?? ""
        let state = weather.state ?? ""
        return "\(city), \(state)"
    }
    
    public var weatherIcon: String {
        return weather.conditions?.icon.weatherSymbol ?? ""
    }
    
    public var summary: String {
        return weather.conditions?.summary ?? ""
    }
    
    public var details: String {
        return weather.conditions?.details ?? ""
    }
    
    public var currentTemperature: String {
        let value = weather.conditions?.temperature ?? 0.0
        let temp = NSNumber(value: value)
        let currentTemp = NumberFormatter.decimal.string(from: temp) ?? "XX"
        return "\(currentTemp)°"
    }
    
    public var highTemperature: String {
        guard let forecast = weather.forecast?.firstObject as? Forecast else { return "XX" }
        
        let temperature = NSNumber(value: forecast.highTemp)
        return NumberFormatter.decimal.string(from: temperature) ?? "XX"
    }
    
    public var lowTemperature: String {
        guard let forecast = weather.forecast?.firstObject as? Forecast else { return "XX" }
        
        let temperature = NSNumber(value: forecast.lowTemp)
        return NumberFormatter.decimal.string(from: temperature) ?? "XX"
    }

    public var day: String {
        guard let forecast = weather.forecast?.firstObject as? Forecast else { return "XX" }
        
        let date = Date(timeIntervalSince1970: forecast.timestamp.timeIntervalSince1970)
        return DateFormatter.dayOfWeek.string(from: date)
    }
    
    public var dataPointsViewModel: DataPointsViewModel? {
        guard let conditions = weather.conditions else { return nil }
        
        let viewModel = DataPointsViewModel(conditions: conditions)
        return viewModel
    }
}
