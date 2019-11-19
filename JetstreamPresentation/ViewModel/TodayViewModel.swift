//
//  TodayViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/29/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamCore

public struct TodayConditionsViewModel {
    let forecast: Forecast?
    
    public var dayOfWeek: String {
        guard let forecast = forecast else { return "" }
        let date = Date(timeIntervalSince1970: forecast.timestamp.timeIntervalSince1970)
        return DateFormatter.dayOfWeek.string(from: date)
    }
    
    public var lowTemperature: String {
        guard let forecast = forecast else { return "" }
        let temperature = NSNumber(value: forecast.lowTemp)
        return NumberFormatter.decimal.string(from: temperature) ?? ""
    }
    
    public var highTemperature: String {
        guard let forecast = forecast else { return "" }
        let temperature = NSNumber(value: forecast.highTemp)
        return NumberFormatter.decimal.string(from: temperature) ?? ""
    }
}
