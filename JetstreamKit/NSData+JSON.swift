//
//  NSData+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public typealias JSONResult = Result<JSON>

extension Data {
    func toJSON() -> JSONResult {
        do {
            let obj = try JSONSerialization.jsonObject(with: self, options: [])
            guard let json = obj as? JSON else { return .failure(JSONError.badFormat) }
            return .success(json)
        } catch (let error) {
            return .failure(JSONError.other(error))
        }
    }
}

public func JSONResultFromData(_ data: Data) -> JSONResult {
    return data.toJSON()
}
