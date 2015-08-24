//
//  NSData+JSON.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias JSONResult = Result<JSON>

extension NSData {
    func toJSON() -> JSONResult {
        
        do {
            if let jsonObject = try NSJSONSerialization.JSONObjectWithData(self, options: []) as? JSON {
                return .Success(jsonObject)
            }
            else {
                return .Failure(.NoData)
            }
        }
        catch (let error as NSError) {
            return .Failure(.Other(error))
        }
        
//        let error : NSError?
//        if let jsonObject = NSJSONSerialization.JSONObjectWithData(self, options: []) as? JSON {
//            return .Success(Box(jsonObject))
//        }
//        else if let err = error {
//            return .Failure(.Other(err))
//        }
//        else {
//            return .Failure(.NoData)
//        }
    }
}

func toJSONResult(result: Result<NSData>) -> JSONResult {
    switch result {
    case .Success(let value):
        return value.toJSON()
    case .Failure(let reason):
        return .Failure(reason)
    }
}