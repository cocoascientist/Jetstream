//
//  Result.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public class Box<T> {
    let unbox: T
    
    init(_ value: T) {
        self.unbox = value
    }
}

public enum Result<T> {
    case Success(Box<T>)
    case Failure(Reason)
}

extension Result {
    func map<U>(transform: T -> U) -> Result<U> {
        switch self {
        case Success(let box):
            return .Success(Box(transform(box.unbox)))
        case Failure(let err):
            return .Failure(err)
        }
    }
    
    func flatMap<U>(transform:T -> Result<U>) -> Result<U> {
        switch self {
        case Success(let value):
            return transform(value.unbox)
        case Failure(let error):
            return .Failure(error)
        }
    }
    
    var description: String {
        switch self {
        case .Success(let box):
            return "value: \(box.unbox)"
        case .Failure(let string):
            return "failure: \(string)"
        }
    }
}