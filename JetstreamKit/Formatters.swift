//
//  Formatters.swift
//  JetstreamKit
//
//  Created by Andrew Shepard on 2/16/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static var dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee"
        return formatter
    }()
    
    public static var clockTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    public static var hourOfDay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter
    }
}

extension NumberFormatter {
    public static var decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
