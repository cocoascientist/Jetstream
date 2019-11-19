//
//  HourlyViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/29/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamCore

public struct HourlyForecastListViewModel {
    let allForecasts: [Forecast]
    
    public var forecasts: [HourlyForecastViewModel] {
        return allForecasts
            .filter { $0.isHourly }
            .prefix(24)
            .map { return HourlyForecastViewModel(forecast: $0) }
    }
}

public struct HourlyForecastViewModel: Hashable {
    let forecast: Forecast
    
    public var timeOfDay: String {
        let date = Date(timeIntervalSince1970: forecast.timestamp.timeIntervalSince1970)
        return DateFormatter.hourOfDay.string(from: date)
    }
    
    public var icon: String {
        return forecast.icon
    }
    
    public var temperature: String {
        let temp = NSNumber(value: forecast.highTemp)
        let stringValue = NumberFormatter.decimal.string(from: temp) ?? ""
        return "\(stringValue)°"
    }
}
