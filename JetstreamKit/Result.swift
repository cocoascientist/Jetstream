//
//  Result.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

protocol ResultType {
    associatedtype Value
    
    init(success value: Value)
    init(failure error: Error)
    
    func map<U>(_ f: (Value) -> U) -> Result<U>
    func flatMap<U>(_ f: (Value) -> Result<U>) -> Result<U>
}

public enum Result<T>: ResultType {
    case success(T)
    case failure(Error)
    
    init(success value: T) {
        self = .success(value)
    }
    
    init(failure error: Error) {
        self = .failure(error)
    }
}

extension Result {
    public func map<U>(_ f: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value):
            return Result<U>.success(f(value))
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
    
    public func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        return Result.flatten(map(f))
    }
    
    private static func flatten<T>(_ result: Result<Result<T>>) -> Result<T> {
        switch result {
        case let .success(innerResult):
            return innerResult
        case let .failure(error):
            return Result<T>.failure(error)
        }
    }
}

public func success<T>(_ value: T) -> Result<T> {
    return .success(value)
}

public func failure<T>(_ error: Error) -> Result<T> {
    return .failure(error)
}
