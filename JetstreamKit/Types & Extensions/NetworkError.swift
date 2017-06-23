//
//  NetworkError.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case badStatusCode(statusCode: Int)
    case badResponse
    case badJSON
    case noData
    case other(error: NSError)
}

extension NetworkError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .badResponse:
            return "Bad response object returned"
        case .badJSON:
            return "Bad JSON object, unable to parse"
        case .noData:
            return "No response data"
        case .badStatusCode(let statusCode):
            return "Bad status code: \(statusCode)"
        case .other(let error):
            return "\(error)"
        }
    }
}
