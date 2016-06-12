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
    init(failure error: ErrorType)
    
    func map<U>(f: (Value) -> U) -> Result<U>
    func flatMap<U>(f: (Value) -> Result<U>) -> Result<U>
}

public enum Result<T>: ResultType {
    case Success(T)
    case Failure(ErrorType)
    
    init(success value: T) {
        self = .Success(value)
    }
    
    init(failure error: ErrorType) {
        self = .Failure(error)
    }
}

extension Result {
    func map<U>(f: (T) -> U) -> Result<U> {
        switch self {
        case let .Success(value):
            return Result<U>.Success(f(value))
        case let .Failure(error):
            return Result<U>.Failure(error)
        }
    }
    
    func flatMap<U>(f: (T) -> Result<U>) -> Result<U> {
        return Result.flatten(map(f))
    }
    
    private static func flatten<T>(result: Result<Result<T>>) -> Result<T> {
        switch result {
        case let .Success(innerResult):
            return innerResult
        case let .Failure(error):
            return Result<T>.Failure(error)
        }
    }
}

public func success<T>(value: T) -> Result<T> {
    return .Success(value)
}

public func failure<T>(error: ErrorType) -> Result<T> {
    return .Failure(error)
}