//
//  DataPointsViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamCore

public struct DataPoint {
    public let name: String
    public let value: String
}

public struct DataPointGroup: Hashable {
    public let first: DataPoint
    public let second: DataPoint
    
    init(_ first: DataPoint, _ second: DataPoint) {
        self.first = first
        self.second = second
    }
    
    public var hashValue: Int {
        return first.name.hashValue ^ first.value.hashValue ^ second.name.hashValue ^ second.value.hashValue
    }
    
//    public func hash(into: Hasher)
    
    public static func == (lhs: DataPointGroup, rhs: DataPointGroup) -> Bool {
        return
            lhs.first.name == rhs.first.name &&
            lhs.first.value == rhs.first.value &&
            lhs.second.name == rhs.second.name &&
            lhs.second.value == rhs.second.value
    }
}

public struct DataPointsViewModel {
    private let conditions: Conditions?
    
    public init(conditions: Conditions?) {
        self.conditions = conditions
    }
    
    public var dataPointGroups: [DataPointGroup] {
        return [windSpeedDataPointGroup, humidityDataPointGroup, sunriseDataPointGroup]
    }
    
    private var windSpeedDataPointGroup: DataPointGroup {
        let windSpeed = DataPoint(name: "Wind Speed", value: "\(conditions?.windSpeed ?? 0)")
        let windBearing = DataPoint(name: "Wind Bearing", value: "\(conditions?.windBearing ?? 0)")
        
        return DataPointGroup(windSpeed, windBearing)
    }
    
    private var humidityDataPointGroup: DataPointGroup {
        let humidity = DataPoint(name: "Humidity", value: "\(conditions?.humidity ?? 0.0)")
        let dewPoint = DataPoint(name: "Dew Point", value: "\(conditions?.dewPoint ?? 0.0)")
        
        return DataPointGroup(humidity, dewPoint)
    }
    
    private var sunriseDataPointGroup: DataPointGroup {
        let sunriseDate = Date(timeIntervalSince1970: conditions?.sunrise?.timeIntervalSince1970 ?? 0)
        let sunsetDate = Date(timeIntervalSince1970: conditions?.sunset?.timeIntervalSince1970 ?? 0)
        
        let sunrise = DataPoint(name: "Sunrise", value: DateFormatter.clockTime.string(from: sunriseDate))
        let sunset = DataPoint(name: "Sunset", value: DateFormatter.clockTime.string(from: sunsetDate))
        
        return DataPointGroup(sunrise, sunset)
    }
}
