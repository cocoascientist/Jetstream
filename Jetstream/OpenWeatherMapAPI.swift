//
//  OpenWeatherMapAPI.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

protocol Path {
    var path: String { get }
}

protocol Request {
    func request() -> NSURLRequest
}

enum OpenWeatherMapAPI {
    case CityID(Int)
    case Seattle
}

extension OpenWeatherMapAPI: Path {
    var baseURL: String {
        return "http://api.openweathermap.org/data/2.5"
    }
    
    var path: String {
        switch self {
            case .CityID(let id):
                return "\(self.baseURL)/weather?id=\(id)"
            case .Seattle:
                return "\(self.baseURL)/weather?id=5809844"
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