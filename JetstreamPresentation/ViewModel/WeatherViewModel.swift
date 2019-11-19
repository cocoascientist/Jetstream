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
        return String("\(windSpeed)")
    }
    
    public var windBearing: String {
        guard let windBearing = weather.conditions?.windBearing else { return "" }
        switch windBearing {
        case 350...360, 0...10:
            return "N"
        case 10...30:
            return "N/NE"
        case 30...50:
            return "NE"
        
        case 300...320:
            return "NW"
        default:
            return ""
        }
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
