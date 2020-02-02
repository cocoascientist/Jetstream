//
//  WeatherViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/29/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamCore

public struct WeatherViewModel {
    let weather: Weather
    
    public init(weather: Weather) {
        self.weather = weather
    }
    
    public var citystate: String {
        return weather.citystate
    }
    
    public var currentTemperature: String {
        return weather.currentTemperature
    }
    
    public var conditionsSummary: String {
        return weather.conditionsSummary
    }
    
    public var icon: String {
        return weather.conditions?.icon ?? ""
    }
    
    public var windSpeed: String {
        guard let windSpeed = weather.conditions?.windSpeed else { return "" }
        return String(format: "%.f", round(windSpeed))
    }
    
    public var windBearing: String {
        guard let windBearing = weather.conditions?.windBearing else { return "" }
        return windBearing.windBearingString
    }
    
    public var humidity: String {
        guard let humidity = weather.conditions?.humidity else { return "" }
        return String(format: "%.f", humidity * 100.0)
    }
    
    public var todayConditionsViewModel: TodayConditionsViewModel {
        let forecast = weather.forecast?.firstObject as? Forecast
        let viewModel = TodayConditionsViewModel(forecast: forecast)
        return viewModel
    }
    
    public var hourlyForecastListViewModel: HourlyForecastListViewModel {
        let forecasts = weather.forecast?.array as? [Forecast] ?? []
        let viewModel = HourlyForecastListViewModel(allForecasts: forecasts)
        return viewModel
    }
    
    public var dayForecastListViewModel: DayForecastListViewModel {
        let forecasts = weather.forecast?.array as? [Forecast] ?? []
        let viewModel = DayForecastListViewModel(allForecasts: forecasts)
        return viewModel
    }
    
    public var summaryForecastViewModel: SummaryViewModel {
        let forecast = weather.forecast?.firstObject as? Forecast
        let viewModel = SummaryViewModel(forecast: forecast)
        return viewModel
    }
    
    public var dataPointsViewModel: DataPointsViewModel {
        let conditions = weather.conditions
        let viewModel = DataPointsViewModel(conditions: conditions)
        return viewModel
    }
}

private extension UInt16 {
    
    // https://stackoverflow.com/a/25867068
    
    private var directions: [String] {
        return ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    }
    
    var windBearingString: String {
        let value = floor((Double(self) / 22.5) + 0.5)
        let index = Int(value.truncatingRemainder(dividingBy: 16.0))
        assert(index < directions.count)
        return directions[index]
    }
}
