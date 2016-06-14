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
    init(failure error: ErrorProtocol)
    
    func map<U>(_ f: (Value) -> U) -> Result<U>
    func flatMap<U>(_ f: (Value) -> Result<U>) -> Result<U>
}

public enum Result<T>: ResultType {
    case success(T)
    case failure(ErrorProtocol)
    
    init(success value: T) {
        self = .success(value)
    }
    
    init(failure error: ErrorProtocol) {
        self = .failure(error)
    }
}

extension Result {
    func map<U>(_ f: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value):
            return Result<U>.success(f(value))
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
    
    func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
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

public func failure<T>(_ error: ErrorProtocol) -> Result<T> {
    return .failure(error)
}
