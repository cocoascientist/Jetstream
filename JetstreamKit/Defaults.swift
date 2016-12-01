//
//  Defaults.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/30/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

public func applicationDefaults() -> [String: Any] {
    let defaults = [
        "cache": NSNumber(value: true), // true for enabled, false otherwise
        "interval": NSNumber(value: 0), // 0 for manual, 1 for 10 minutes, 2 for 30
        "units": NSNumber(value: 0) // 0 for automatic, 1 for celsius
    ]
    
    return defaults
}
