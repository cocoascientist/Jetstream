//
//  Formatters.swift
//  JetstreamKit
//
//  Created by Andrew Shepard on 2/16/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation

public extension DateFormatter {
    static var dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        #if os(iOS)
        formatter.dateFormat = "eeee"
        #elseif os(macOS)
        formatter.dateFormat = "eee"
        #endif
        return formatter
    }()
    
    static var clockTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    static var hourOfDay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter
    }
}

public extension NumberFormatter {
    static var decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
