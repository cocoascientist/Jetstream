//
//  Future.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/19/15.
//  Copyright © 2015 Andrew Shepard. All rights reserved.
//

// https://realm.io/news/swift-summit-javier-soto-futures/

public protocol FutureType {
    associatedtype Value
    associatedtype Error
    
    init(value: Value)
    init(error: Error)
}

public struct Future<Value, Error: Swift.Error>: FutureType {
    public typealias ResultType = Result<Value, Error>
    public typealias Completion = (ResultType) -> ()
    public typealias AsyncOperation = (@escaping Completion) -> ()
    
    private let operation: AsyncOperation
    
    public init(value result: ResultType) {
        self.init(operation: { completion in
            completion(result)
        })
    }
    
    public init(error: Error) {
        self.init(operation: { completion in
            completion(.failure(error))
        })
    }
    
    public init(operation: @escaping AsyncOperation) {
        self.operation = operation
    }
    
    public func start(_ completion: @escaping Completion) {
        self.operation() { result in
            completion(result)
        }
    }
}

extension Future {
    func map<U>(f: @escaping (Value) -> U) -> Future<U, Error> {
        return Future<U, Error>(operation: { completion in
            self.start { result in
                switch result {
                case .success(let value):
                    completion(Result.success(f(value)))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        })
    }
    
    func flatMap<U>(f: @escaping (Value) -> Future<U, Error>) -> Future<U, Error> {
        return Future<U, Error>(operation: { completion in
            self.start { result in
                switch result {
                case .success(let value): f(value).start(completion)
                case .failure(let error): completion(Result.failure(error))
                }
            }
        })
    }
}
