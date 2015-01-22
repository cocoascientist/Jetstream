//
//  OpenWeatherMapAPI.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

protocol Path {
    var path: String { get }
}

protocol Request {
    func request() -> NSURLRequest
}

enum OpenWeatherMapAPI {
    case Conditions(String, String)
    
    case Forecast(CLLocationCoordinate2D)
    case LocationsNear(CLLocationCoordinate2D)
}

extension OpenWeatherMapAPI: Path {
    var baseURL: String {
        return "http://api.openweathermap.org/data/2.5"
    }
    
    var path: String {
        switch self {
            case .Conditions(let city, let state):
                return "\(self.baseURL)/weather?q=\(city),\(state)"
            case .Forecast(let coord):
                return "\(self.baseURL)/forecast/daily?lat=\(coord.latitude)&lon=\(coord.longitude)&cnt=5"
            case .LocationsNear(let coord):
                return "\(self.baseURL)/find?lat=\(coord.latitude)&lon=\(coord.longitude)"
        }
    }
}

extension OpenWeatherMapAPI: Request {
    func request() -> NSURLRequest {
        let path = self.path
        let url = NSURL(string: path)
        return NSURLRequest(URL: url!)
    }
}