//
//  ForecastAPI.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

enum ForecastAPI {
    case Forecast(CLLocation)
}

extension ForecastAPI {
    private var apiKey: String {
        // register for an API key at https://developer.forecast.io/register
        // replace the value below with your API key, and return it
        
        // return "a43c1a2dd8655c8d9493e01a19b5a329"
        
        // remove the fatalError once your API key is set above
        fatalError("apiKey not set")
    }
    
    private var baseURL: String {
        return "https://api.forecast.io"
    }
    
    private var path: String {
        switch self {
        case .Forecast(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "\(baseURL)/forecast/\(apiKey)/\(latitude),\(longitude)"
        }
    }
    
    func request() -> NSURLRequest {
        let path = self.path
        let url = NSURL(string: path)
        return NSURLRequest(URL: url!)
    }
}