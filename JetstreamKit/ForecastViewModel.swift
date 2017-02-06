//
//  ForecastsViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public struct ForecastsViewModel {
    private let weather: Weather
    
    public init(weather: Weather) {
        self.weather = weather
    }
    
    public var hourlyForecasts: [ForecastViewModel] {
        guard let forecasts = self.weather.forecast?.array as? [Forecast] else { return [] }
        let hourlyForecasts = forecasts.filter { return $0.isHourly }
        let limit = min(hourlyForecasts.count, 24)
        
        let viewModels = hourlyForecasts[0..<limit].map { (forecast) -> ForecastViewModel in
            ForecastViewModel(forecast: forecast)
        }
        
        return viewModels
    }
    
    public var dailyForecasts: [ForecastViewModel] {
        guard let forecasts = self.weather.forecast?.array as? [Forecast] else { return [] }
        let dailyForecasts = forecasts.filter { return !$0.isHourly }
        
        let viewModels = dailyForecasts.map { (forecast) -> ForecastViewModel in
            ForecastViewModel(forecast: forecast)
        }
        
        return viewModels
    }
}

public struct ForecastViewModel {
    private let forecast: Forecast
    
    public init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    public var summary: String {
        return self.forecast.summary ?? ""
    }
    
    public var weatherIcon: String {
        return self.forecast.icon?.weatherSymbol ?? ""
    }
    
    public var dayOfWeek: String {
        let date = Date(timeIntervalSince1970: forecast.timestamp!.timeIntervalSince1970)
        return dayOfWeekFormatter.string(from: date)
    }
    
    public var hourOfDay: String {
        let date = Date(timeIntervalSince1970: forecast.timestamp!.timeIntervalSince1970)
        return hourOfDayFormatter.string(from: date)
    }
    
    public var lowTemp: String {
        let value = self.forecast.lowTemp
        let temp = NSNumber(value: value)
        let tempString = self.numberFormatter.string(from: temp) ?? "XX"
        return "\(tempString)"
    }
    
    public var highTemp: String {
        let value = self.forecast.highTemp
        let temp = NSNumber(value: value)
        let tempString = self.numberFormatter.string(from: temp) ?? "XX"
        return "\(tempString)"
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    private var dayOfWeekFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee"
        
        return formatter
    }
    
    private var hourOfDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        
        return formatter
    }
}
