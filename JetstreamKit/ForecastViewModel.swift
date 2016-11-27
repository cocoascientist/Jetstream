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
    
    public var forecasts: [ForecastViewModel] {
        guard let forecasts = self.weather.forecast?.array as? [Forecast] else { return [] }
        let viewModels = forecasts.map { (forecast) -> ForecastViewModel in
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
    
    public var lowTemp: String {
        let value = self.forecast.lowTemp
        let temp = NSNumber(value: value)
        let tempString = self.numberFormatter.string(from: temp) ?? "XX"
        return "\(tempString)°"
    }
    
    public var highTemp: String {
        let value = self.forecast.highTemp
        let temp = NSNumber(value: value)
        let tempString = self.numberFormatter.string(from: temp) ?? "XX"
        return "\(tempString)°"
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    private var dayOfWeekFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        
        return formatter
    }
}
