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
        let expectation = self.expectation(withDescription: "Request be successful")
        let configuration = URLSessionConfiguration.configurationWithProtocol(LocalURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let request = ForecastAPI.forecast(location).request()
        
        networkController.startRequest(request, result: { (result) -> Void in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Request should not fail")
            }
        })
        
        waitForExpectations(withTimeout: 60.0, handler: nil)
    }
    
    func testCanHandleBadStatusCode() {
        let expectation = self.expectation(withDescription: "Request should not be successful")
        let configuration = URLSessionConfiguration.configurationWithProtocol(FailingURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        
        let location = CLLocation(latitude: 25.7877, longitude: -80.2241)
        let request = ForecastAPI.forecast(location).request()
        
        networkController.startRequest(request, result: { (result) -> Void in
            switch result {
            case .success:
                XCTFail("Request should fail")
            case .failure:
                expectation.fulfill()
            }
        })
        
        waitForExpectations(withTimeout: 60.0, handler: nil)
    }
}
