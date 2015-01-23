//
//  ForecastViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    private let forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    var forecastString: String {
        let symbol = self.forecast.conditions.icon.symbolForCurrentWeather()
        let day = self.formatter.stringFromDate(self.forecast.date)
        return "\(symbol)  \(day)"
    }
    
    private var formatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
}