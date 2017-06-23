//
//  Weather+Location.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/17/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import Foundation
import CoreLocation

extension Weather {
    public var location: Location {
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        return Location(location: loc, city: city ?? "", state: state ?? "")
    }
}
