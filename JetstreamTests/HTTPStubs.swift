//
//  HTTPStubs.swift
//  HTTPStubs
//
//  Created by Andrew Shepard on 2/12/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

typealias ResponseStub = (request: NSURLRequest) -> Result<NSURLResponse>
typealias RequestComparison = (request: NSURLRequest) -> Bool
typealias Stub = (comparison: RequestComparison, response: ResponseStub)

class HTTPStubs {
    
    private var stubs: [Stub] = []
    
    private class var sharedInstance : HTTPStubs {
        struct Static {
            static var instance = HTTPStubs()
        }
        
        return Static.instance
    }
    
    class func stubRequestsMatching(comparison: RequestComparison, with response: ResponseStub) -> Void {
        let stub = Stub(comparison: comparison, response: response)
        HTTPStubs.sharedInstance.stubs.append(stub)
    }
    
    class func stubRequestsWith(response: ResponseStub) -> Void {
        HTTPStubs.removeAllStubs()
        
        self.stubRequestsMatching({ (request) -> Bool in
            return true
        }, with: response)
    }
    
    class func shouldStubRequest(request: NSURLRequest) -> Bool {
        return (HTTPStubs.sharedInstance.stubs.first != nil)
    }
    
    class func stubForRequest(request: NSURLRequest) -> ResponseStub? {
        // TODO: implement matching support
        
        if let stub = HTTPStubs.sharedInstance.stubs.first {
            return stub.response
        }
        
        return nil
    }
    
    class func removeAllStubs() -> Void {
        HTTPStubs.sharedInstance.stubs.removeAll(keepCapacity: false)
    }
}

class StubURLProtocol: NSURLProtocol {
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return HTTPStubs.shouldStubRequest(request)
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
        
        let failure: (reason: Reason) -> Void = { (reason) in
            let error = NSError(domain: "org.andyshep.StubURLProtocol", code: -101, userInfo: nil)
            self.client?.URLProtocol(self, didFailWithError: error)
            self.client?.URLProtocolDidFinishLoading(self)
        }
        
        let success: (response: NSURLResponse) -> Void = { (response) in
            self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
            self.client?.URLProtocol(self, didLoadData: NSData())
            self.client?.URLProtocolDidFinishLoading(self)
        }
        
        if let stub = HTTPStubs.stubForRequest(request) {
            let response = stub(request: request)
            
            switch response {
            case .Success(let box):
                success(response: box.unbox)
            case .Failure(let reason):
                failure(reason: reason)
            }
        }
        else {
            assert(false, "Should have found a stub")
        }
    }
    
    override func stopLoading() {
        // TODO
    }
}

extension NSURLSessionConfiguration {
    
    override public class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }

        if self !== NSURLSessionConfiguration.self {
            return
        }
        
        dispatch_once(&Static.token, { () -> Void in
            let originalSelector = Selector("defaultSessionConfiguration")
            let swizzledSelector = Selector("HTTPStubs_defaultSessionConfiguration")
            
            let originalMethod = class_getClassMethod(NSURLSessionConfiguration.self, originalSelector)
            let swizzledMethod = class_getClassMethod(NSURLSessionConfiguration.self, swizzledSelector)
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        })
    }
    
    class func HTTPStubs_defaultSessionConfiguration() -> NSURLSessionConfiguration! {
        var protocolClasses: [AnyObject] = []
        let configuration = HTTPStubs_defaultSessionConfiguration()
        
        for protocolClass in configuration.protocolClasses! {
            protocolClasses.append(protocolClass)
        }
        
        protocolClasses.insert(StubURLProtocol.classForCoder(), atIndex: 0)
        configuration.protocolClasses = protocolClasses
        
        return configuration
    }
}