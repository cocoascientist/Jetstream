//
//  DarkSkyAPI.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

public enum DarkSkyAPI {
    case forecast(CLLocation)
}

extension DarkSkyAPI {
    private var apiKey: String {
        // register for an API key at https://darksky.net/dev/register
        // replace the value below with your API key, and return it
        // remove the fatalError once your API key is set above
        fatalError("apiKey not set")
    }
    
    private var baseURL: String {
        return "https://api.darksky.net"
    }
    
    private var path: String {
        switch self {
        case .forecast(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "\(baseURL)/forecast/\(apiKey)/\(latitude),\(longitude)?exclude=flags,hourly,minutely&units=\(units)"
        }
    }
    
    public var request: URLRequest {
        let path = self.path
        let url = URL(string: path)
        return URLRequest(url: url!)
    }
    
    private var units: String {
        let units = UserDefaults.standard.integer(forKey: "units")
        
        switch units {
        case 1:
            return "si"
        case 2:
            return "us"
        default:
            return "auto"
        }
    }
}


