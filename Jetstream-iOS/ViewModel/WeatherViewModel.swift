//
//  WeatherViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/29/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamKit

struct WeatherViewModel {
    let weather: Weather
    
    var citystate: String {
        return weather.citystate
    }
    
    var currentTemperature: String {
        return weather.currentTemperature
    }
    
    var conditionsSummary: String {
        return weather.conditionsSummary
    }
    
    var todayConditionsViewModel: TodayConditionsViewModel {
        let forecast = weather.forecast?.firstObject as? Forecast
        let viewModel = TodayConditionsViewModel(forecast: forecast)
        return viewModel
    }
    
    var hourlyForecastListViewModel: HourlyForecastListViewModel {
        let forecasts = weather.forecast?.array as? [Forecast] ?? []
        let viewModel = HourlyForecastListViewModel(allForecasts: forecasts)
        return viewModel
    }
    
    var dailyForecastListViewModel: DayForecastListViewModel {
        let forecasts = weather.forecast?.array as? [Forecast] ?? []
        let viewModel = DayForecastListViewModel(allForecasts: forecasts)
        return viewModel
    }
    
    var summaryForecastViewModel: SummaryViewModel {
        let forecast = weather.forecast?.firstObject as? Forecast
        let viewModel = SummaryViewModel(forecast: forecast)
        return viewModel
    }
}
