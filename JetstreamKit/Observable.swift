//
//  Observable.swift
//  Jetstream
//
//  Created by Andrew Shepard on 3/23/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

// http://colindrake.me/2015/10/01/an-observable-pattern-implementation-in-swift/

protocol ObservableType {
    associatedtype Value
    var value: Value { get set }
    
    func subscribe(observer: AnyObject, change: @escaping (_ new: Value, _ old: Value) -> ())
    func unsubscribe(observer: AnyObject)
}

public final class Observable<T>: ObservableType {
    typealias Change = (_ new: T, _ old: T) -> ()
    typealias ObserversEntry = (observer: AnyObject, change: Change)
    
    private var observers: [ObserversEntry]
    
    init(_ value: T) {
        self.value = value
        self.observers = []
    }
    
    var value: T {
        didSet {
            observers.forEach { (entry: ObserversEntry) in
                let (_, block) = entry
                block(value, oldValue)
            }
        }
    }
    
    func subscribe(observer: AnyObject, change: @escaping Change) {
        let entry: ObserversEntry = (observer: observer, change: change)
        observers.append(entry)
    }
    
    func unsubscribe(observer: AnyObject) {
        let filtered = observers.filter { entry in
            let (owner, _) = entry
            return owner !== observer
        }
        
        observers = filtered
    }
}
