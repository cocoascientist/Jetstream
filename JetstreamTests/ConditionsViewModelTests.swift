//
//  ConditionsViewModelTests.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/12/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

class ConditionsViewModelTests: XCTestCase {
    
    var weather: Weather {
        let conditions = Conditions(description: "Sunny", icon: "01d")
        let temperatures = Temperatures(current: 70.0, max: 75.0, min: 65.0)
        return Weather(name: "Austin", conditions: conditions, temperatures: temperatures)
    }
    
    var viewModel: ConditionsViewModel {
        return ConditionsViewModel(weather: weather)
    }

    func testCityName() {
        XCTAssertTrue(viewModel.cityName == "Austin", "City should be Austin")
    }
    
    func testCurrentConditions() {
        XCTAssertTrue(viewModel.currentConditions == "\u{f00d} Sunny", "Current Conditions should be Sunny")
    }
}
