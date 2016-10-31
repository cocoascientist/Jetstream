//
//  ForecastViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public struct ForecastViewModel {
    private let forecast: Forecast
    
    public init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    public var dayString: String {
        return self.formatter.string(from: self.forecast.date)
    }
    
    public var weatherIcon: String {
        return self.forecast.icon.weatherSymbol
    }
    
    public var temperatureRange: String {
        let min = String(format: "%.1f", self.forecast.range.min)
        let max = String(format: "%.1f", self.forecast.range.max)
        return "\(max)°\u{FF0F} \(min)°"
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
}
