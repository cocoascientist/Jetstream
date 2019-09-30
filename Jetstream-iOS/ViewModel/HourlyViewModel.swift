//
//  HourlyViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/29/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamKit

struct HourlyForecastListViewModel {
    let allForecasts: [Forecast]
    
    var forecasts: [HourlyForecastViewModel] {
        return allForecasts
            .filter { $0.isHourly }
            .prefix(24)
            .map { return HourlyForecastViewModel(forecast: $0) }
    }
}

struct HourlyForecastViewModel: Hashable {
    let forecast: Forecast
    
    var timeOfDay: String {
        let date = Date(timeIntervalSince1970: forecast.timestamp.timeIntervalSince1970)
        return DateFormatter.hourOfDay.string(from: date)
    }
    
    var icon: String {
        return forecast.icon
    }
    
    var temperature: String {
        let temp = NSNumber(value: forecast.highTemp)
        return NumberFormatter.decimal.string(from: temp) ?? ""
    }
}
