//
//  NSData+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias JSONResult = Result<JSON>

extension NSData {
    func toJSON() -> JSONResult {
        do {
            let obj = try NSJSONSerialization.JSONObjectWithData(self, options: [])
            guard let json = obj as? JSON else { return .Failure(JSONError.BadFormat) }
            return .Success(json)
        }
        catch (let error) {
            return .Failure(JSONError.Other(error))
        }
    }
}

func JSONResultFromData(data: NSData) -> JSONResult {
    return data.toJSON()
}