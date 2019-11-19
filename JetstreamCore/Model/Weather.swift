//
//  Weather+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/20/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreData

public protocol WeatherDescribing {
    var citystate: String { get }
    var conditionsSummary: String { get }
    var currentTemperature: String { get }
}

public class Weather: NSManagedObject, Decodable {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    @NSManaged public var state: String?
    @NSManaged public var city: String?
    
    @NSManaged public var conditions: Conditions?
    @NSManaged public var forecast: NSOrderedSet?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        guard let location = decoder.userInfo[.location] as? Location else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        
        self.conditions = try Conditions(from: decoder)
        do {
            let something = try Forecast.forecasts(from: decoder)
            self.forecast = NSOrderedSet(array: something)
        } catch {
            print(error)
        }
        
        self.city = location.city
        self.state = location.state
    }
}

public extension Weather {
    static func defaultFetchRequest() -> NSFetchRequest<Weather> {
        let request = NSFetchRequest<Weather>(entityName: "Weather")
        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        
        return request
    }
}

extension Weather: WeatherDescribing {
    public var citystate: String {
        guard let city = city, let state = state else { return "" }
        return "\(city), \(state)"
    }
    
    public var conditionsSummary: String {
        return conditions?.summary ?? ""
    }
    
    public var currentTemperature: String {
        guard let temperature = conditions?.temperature else { return "" }
        let doubleValue = NSNumber(value: temperature)
        guard let temperatureString = NumberFormatter.decimal.string(from: doubleValue) else { return "" }
        return "\(temperatureString)°"
    }
}
