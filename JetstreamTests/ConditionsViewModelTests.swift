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
    
    var conditions: Conditions {
        return Conditions(summary: "Sunny", icon: "\0d", temperature: 70.0, time: NSDate().timeIntervalSince1970)
    }
    
    var viewModel: ConditionsViewModel {
        return ConditionsViewModel(conditions: conditions)
    }

    func testCityName() {
        XCTAssertTrue(viewModel.cityName == "Austin", "City should be Austin")
    }
    
    func testCurrentConditions() {
        XCTAssertTrue(viewModel.currentConditions == "\u{f00d} Sunny", "Current Conditions should be Sunny")
    }
}
