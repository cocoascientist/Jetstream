//
//  Weather.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Temperatures {
    let currentTemp: NSNumber
    let maxTemp: NSNumber
    let minTemp: NSNumber
    
    init(current: NSNumber, max: NSNumber, min: NSNumber) {
        self.maxTemp = max
        self.minTemp = min
        self.currentTemp = current
    }
}

struct Forecast {
    private let datetime: NSNumber
    let conditions: Conditions
    
    init(datetime: NSNumber, conditions: Conditions) {
        self.datetime = datetime
        self.conditions = conditions
    }
    
    var date: NSDate {
        get {
            return NSDate(timeIntervalSince1970: self.datetime.doubleValue)
        }
    }
}

extension Temperatures {
    static func temperaturesFromJSON(json: JSON) -> Temperatures? {
        if let current = json["temp"] as? NSNumber,
            let max = json["temp_max"] as? NSNumber,
            let min = json["temp_min"] as? NSNumber {
                
            let temperatures = Temperatures(current: current, max: max, min: min)
            return temperatures
        }
        
        return nil
    }
}

extension Forecast {
    static func forecastFromJSON(json: JSON) -> Forecast? {
        if let datetime = json["dt"] as? NSNumber,
            let weather = json["weather"] as? [AnyObject],
            let conditionsObj = weather.first as? JSON,
            let conditions = Conditions.conditionsFromJSON(conditionsObj) {
                
            let forecast = Forecast(datetime: datetime, conditions: conditions)
            return forecast
        }
        
        return nil
    }
    
    static func forecastsFromJSON(json: JSON) -> [Forecast]? {
        var forecasts: [Forecast]? = nil
        if let list = json["list"] as? [JSON] {
            forecasts = []
            for obj in list {
                if let forecast = self.forecastFromJSON(obj) {
                    forecasts?.append(forecast)
                }
            }
        }
        
        return forecasts
    }
}

extension NSNumber {
    func toCelsius() -> NSNumber {
        return self.doubleValue - 273.15
    }
    
    func toFahrenheit() -> NSNumber {
        return (self.toCelsius().doubleValue * 9) / 5 + 32
    }
}