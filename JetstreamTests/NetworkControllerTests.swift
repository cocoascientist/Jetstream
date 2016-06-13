//
//  NetworkControllerTests.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/12/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class NetworkControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSuccessfulResponse() -> Void {
        let expectation = expectationWithDescription("Request be successful")
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(LocalURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let request = ForecastAPI.Forecast(location).request()
        
        networkController.startRequest(request, result: { (result) -> Void in
            switch result {
            case .Success:
                expectation.fulfill()
            case .Failure:
                XCTFail("Request should not fail")
            }
        })
        
        waitForExpectationsWithTimeout(60.0, handler: nil)
    }
    
    func testCanHandleBadStatusCode() {
        let expectation = expectationWithDescription("Request should not be successful")
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(FailingURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let request = ForecastAPI.Forecast(location).request()
        
        networkController.startRequest(request, result: { (result) -> Void in
            switch result {
            case .Success:
                XCTFail("Request should fail")
            case .Failure:
                expectation.fulfill()
            }
        })
        
        waitForExpectationsWithTimeout(60.0, handler: nil)
    }
}