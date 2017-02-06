//
//  DataPointsViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/7/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import Foundation

public struct DataPoint {
    public let name: String
    public let value: String
}

public struct DataPointGroup {
    public let first: DataPoint
    public let second: DataPoint
    
    init(_ first: DataPoint, _ second: DataPoint) {
        self.first = first
        self.second = second
    }
}

public struct DataPointsViewModel {
    private let conditions: Conditions
    
    public init(conditions: Conditions) {
        self.conditions = conditions
    }
    
    public var dataPointGroups: [DataPointGroup] {
        return [windSpeedDataPointGroup, humidityDataPointGroup, sunriseDataPointGroup]
    }
    
    private var windSpeedDataPointGroup: DataPointGroup {
        let windSpeed = DataPoint(name: "Wind Speed", value: "\(conditions.windSpeed)")
        let windBearing = DataPoint(name: "Wind Bearing", value: "\(conditions.windBearing)")
        
        return DataPointGroup(windSpeed, windBearing)
    }
    
    private var humidityDataPointGroup: DataPointGroup {
        let humidity = DataPoint(name: "Humidity", value: "\(conditions.humidity)")
        let dewPoint = DataPoint(name: "Dew Point", value: "\(conditions.dewPoint)")
        
        return DataPointGroup(humidity, dewPoint)
    }
    
    private var sunriseDataPointGroup: DataPointGroup {
        let sunriseDate = Date(timeIntervalSince1970: conditions.sunrise?.timeIntervalSince1970 ?? 0)
        let sunsetDate = Date(timeIntervalSince1970: conditions.sunset?.timeIntervalSince1970 ?? 0)
        
        let sunrise = DataPoint(name: "Sunrise", value: dateFormatter.string(from: sunriseDate))
        let sunset = DataPoint(name: "Sunset", value: dateFormatter.string(from: sunsetDate))
        
        return DataPointGroup(sunrise, sunset)
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        return formatter
    }()
}
