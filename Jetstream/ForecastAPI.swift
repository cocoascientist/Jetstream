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
    case forecast(CLLocation)
}

extension ForecastAPI {
    private var apiKey: String {
        // register for an API key at https://developer.forecast.io/register
        // replace the value below with your API key, and return it
        
         return "db490f7c324fef73c891e5ca013dd88c"
        
        // remove the fatalError once your API key is set above
//        fatalError("apiKey not set")
    }
    
    private var baseURL: String {
        return "https://api.forecast.io"
    }
    
    private var path: String {
        switch self {
        case .forecast(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "\(baseURL)/forecast/\(apiKey)/\(latitude),\(longitude)"
        }
    }
    
    func request() -> URLRequest {
        let path = self.path
        let url = URL(string: path)
        return URLRequest(url: url!)
    }
}
