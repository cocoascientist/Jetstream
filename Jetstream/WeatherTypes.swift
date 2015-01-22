//
//  Weather.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

struct Weather {
    let name: String
    let conditions: Conditions
    let temperatures: Temperatures
    
    init(name: String, conditions: Conditions, temperatures: Temperatures) {
        self.name = name
        self.conditions = conditions
        self.temperatures = temperatures
    }
}

struct Conditions {
//    let status: String
    let description: String
    let icon: String
    
    init(description: String, icon: String) {
        self.description = description
        self.icon = icon
    }
}

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
    let datetime: NSNumber
    let conditions: Conditions
    
    init(datetime: NSNumber, conditions: Conditions) {
        self.datetime = datetime
        self.conditions = conditions
    }
}

extension Weather {
    static func weatherFromJSON(json: JSON) -> Weather? {
        if let name = json["name"] as? String {
            if let weather = json["weather"] as? [AnyObject] {
                if let conditionsObj = weather.first as? JSON {
                    if let conditions = Conditions.conditionsFromJSON(conditionsObj) {
                        if let tempsObj = json["main"] as? JSON {
                            if let temperatures = Temperatures.temperaturesFromJSON(tempsObj) {
                                let weather = Weather(name: name, conditions: conditions, temperatures: temperatures)
                                return weather
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
}

extension Conditions {
    static func conditionsFromJSON(json: JSON) -> Conditions? {
        if let status = json["main"] as? String {
            if let description = json["description"] as? String {
                if let icon = json["icon"] as? String {
                    let conditions = Conditions(description: description, icon: icon)
                    return conditions
                }
            }
        }
        
        return nil
    }
}

extension Temperatures {
    static func temperaturesFromJSON(json: JSON) -> Temperatures? {
        if let current = json["temp"] as? NSNumber {
            if let max = json["temp_max"] as? NSNumber {
                if let min = json["temp_min"] as? NSNumber {
                    let temperatures = Temperatures(current: current, max: max, min: min)
                    return temperatures
                }
            }
        }
        
        return nil
    }
}

extension Forecast {
    static func forecastFromJSON(json: JSON) -> Forecast? {
        if let datetime = json["dt"] as? NSNumber {
            if let weather = json["weather"] as? [AnyObject] {
                if let conditionsObj = weather.first as? JSON {
                    if let conditions = Conditions.conditionsFromJSON(conditionsObj) {
                        let forecast = Forecast(datetime: datetime, conditions: conditions)
                        return forecast
                    }
                }
            }
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