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
    
    var dayString: String {
        return self.formatter.stringFromDate(self.forecast.date)
    }
    
    var weatherIcon: String {
        return self.forecast.icon.symbolForCurrentWeather()
    }
    
    var temperatureRange: String {
        let min = String(format: "%.1f", self.forecast.temperature.min)
        let max = String(format: "%.1f", self.forecast.temperature.max)
        return "\(max)°\u{FF0F} \(min)°"
    }
    
    private var formatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
}