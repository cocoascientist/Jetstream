//
//  DayViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/29/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamKit

struct DayForecastListViewModel {
    let allForecasts: [Forecast]
    
    var forecasts: [DayForecastViewModel] {
        return allForecasts
            .filter { !$0.isHourly }
            .map { return DayForecastViewModel(forecast: $0) }
    }
}

struct DayForecastViewModel: Hashable {
    let forecast: Forecast
    
    var dayOfWeek: String {
        let date = Date(timeIntervalSince1970: forecast.timestamp.timeIntervalSince1970)
        return DateFormatter.dayOfWeek.string(from: date)
    }
    
    var icon: String {
        return forecast.icon
    }
    
    var high: String {
        let temp = NSNumber(value: forecast.highTemp)
        return NumberFormatter.decimal.string(from: temp) ?? ""
    }
    
    var low: String {
        let temp = NSNumber(value: forecast.lowTemp)
        return NumberFormatter.decimal.string(from: temp) ?? ""
    }
}
