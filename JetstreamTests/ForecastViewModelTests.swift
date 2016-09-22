//
//  ForecastViewModelTests.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/11/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest
@testable import Jetstream

class ForecastViewModelTests: XCTestCase {
    
    var forecast: Forecast {
        let range = TemperatureRange(min: 70.0, max: 70.0)
        return Forecast(timestamp: 1423756292, summary: "Sunny", icon: "clear-day", range: range)
    }
    
    var viewModel: ForecastViewModel {
        return ForecastViewModel(forecast: forecast)
    }

    func testWeatherIcon() {
        XCTAssertTrue(viewModel.weatherIcon == "\u{f00d}", "Weather Icon should be Clear Day")
    }
    
    func testDayOfWeek() {
        XCTAssertTrue(viewModel.dayString == "Thursday", "Day should be Thursday")
    }
}
