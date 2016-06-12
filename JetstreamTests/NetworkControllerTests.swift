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
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testSuccessfulResponse() -> Void {
        let expectation = expectationWithDescription("Expected successful result")
        let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let request = ForecastAPI.Forecast(location).request()
        
        HTTPStubs.stubRequestsWith { (request) -> Result<NSURLResponse> in
            let headers = request.allHTTPHeaderFields
            let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: headers)!
            return Result.Success(response)
        }
        
        let result: TaskResult = { (result) -> Void in
            switch result {
            case .Success:
                expectation.fulfill()
            case .Failure:
                XCTAssertTrue(false, "Should not have failed")
            }
        }
        
        let task = NetworkController.task(request, result: result)
        task.resume()
        
        waitForExpectationsWithTimeout(2.0) { (error) in
            task.cancel()
        }
    }
    
    func testFailedResponse() -> Void {
        let expectation = expectationWithDescription("Expected failed result")
        let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let request = ForecastAPI.Forecast(location).request()
        
        HTTPStubs.stubRequestsWith { (request) -> Result<NSURLResponse> in
            return Result.Failure(Reason.NoData)
        }
        
        let result: TaskResult = { (result) -> Void in
            switch result {
            case .Success:
                XCTAssertTrue(false, "Should not have succeeded")
            case .Failure:
                expectation.fulfill()
            }
        }
        
        let task = NetworkController.task(request, result: result)
        task.resume()
        
        waitForExpectationsWithTimeout(2.0) { (error) in
            task.cancel()
        }
    }
}