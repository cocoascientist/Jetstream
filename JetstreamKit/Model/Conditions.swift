//
//  Conditions+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

public class Conditions: NSManagedObject, Decodable {
    @NSManaged var icon: String
    @NSManaged var details: String
    @NSManaged var summary: String
    
    @NSManaged var time: Date
    @NSManaged var sunrise: Date?
    @NSManaged var sunset: Date?
    
    @NSManaged var apparentTemperature: Double
    @NSManaged var temperature: Double
    
    @NSManaged var humidity: Double
    @NSManaged var dewPoint: Double
    
    @NSManaged var cloudCover: Double
    @NSManaged var visibility: Double
    
    @NSManaged var windSpeed: Double
    @NSManaged var windBearing: UInt16
    
    @NSManaged var lastUpdated: Date
    
    enum WrapperKeys: String, CodingKey {
        case currently
        case daily
    }
    
    enum CurrentlyKeys: String, CodingKey {
        case icon
        case temperature
        case dewPoint
        case humidity
        case windSpeed
        case windBearing
        case summary
        case cloudCover
        case visibility
        case apparentTemperature
    }
    
    enum DailyKeys: String, CodingKey {
        case data
        case details = "summary"
    }
    
    private struct SunTime: Codable {
        enum CodingKeys: String, CodingKey {
            case sunset = "sunsetTime"
            case sunrise = "sunriseTime"
        }
        
        let sunset: Double
        let sunrise: Double
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Conditions", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let wrapper = try decoder.container(keyedBy: WrapperKeys.self)
        let currently = try wrapper.nestedContainer(keyedBy: CurrentlyKeys.self, forKey: .currently)
        self.icon = try currently.decode(String.self, forKey: .icon)
        self.summary = try currently.decode(String.self, forKey: .summary)
        
        self.temperature = try currently.decode(Double.self, forKey: .temperature)
        self.apparentTemperature = try currently.decode(Double.self, forKey: .apparentTemperature)
        
        self.dewPoint = try currently.decode(Double.self, forKey: .dewPoint)
        self.humidity = try currently.decode(Double.self, forKey: .humidity)
        
        self.visibility = try currently.decode(Double.self, forKey: .cloudCover)
        self.cloudCover = try currently.decode(Double.self, forKey: .visibility)
        
        self.windSpeed = try currently.decode(Double.self, forKey: .windSpeed)
        self.windBearing = try currently.decode(UInt16.self, forKey: .windBearing)
        
        let daily = try wrapper.nestedContainer(keyedBy: DailyKeys.self, forKey: .daily)
        self.details = try daily.decode(String.self, forKey: .details)
        
        let suntimes = try daily.decode([SunTime].self, forKey: .data)
        
        self.sunset = Date(timeIntervalSince1970: suntimes.first?.sunset ?? 0)
        self.sunrise = Date(timeIntervalSince1970: suntimes.first?.sunset ?? 0)
        
        self.lastUpdated = Date()
    }
}
