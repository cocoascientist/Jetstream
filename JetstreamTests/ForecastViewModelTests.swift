//
//  ForecastViewModelTests.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/11/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

class ForecastViewModelTests: XCTestCase {
    
    var forecast: Forecast {
        let conditions = Conditions(description: "Sunny", icon: "01d")
        let date = NSDate(timeIntervalSince1970: 1423756292)
        return Forecast(datetime: date.timeIntervalSince1970, conditions: conditions)
    }
    
    var viewModel: ForecastViewModel {
        return ForecastViewModel(forecast: forecast)
    }

    func testWeatherIcon() {
        XCTAssertTrue(viewModel.weatherIcon == "\u{f00d}", "Weather Icon should be Sunny")
    }
    
    func testDayOfWeek() {
        XCTAssertTrue(viewModel.dayString == "Thursday", "Day should be Thursday")
    }
}
