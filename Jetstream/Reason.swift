//
//  Reason.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/25/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public enum Reason {
    case BadResponse
    case NoData
    case NoSuccessStatusCode(statusCode: Int)
    case Other(NSError)
}

extension Reason: Printable {
    public var description: String {
        switch self {
        case .BadResponse:
            return "Bad response object returned"
        case .NoData:
            return "No response data"
        case .NoSuccessStatusCode(let code):
            return "Bad status code: \(code)"
        case .Other(let error):
            return "\(error)"
        }
    }
}