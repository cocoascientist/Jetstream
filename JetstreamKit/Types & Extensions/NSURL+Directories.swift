//
//  NSURL+Directories.swift
//  GROCloudStore
//
//  Created by Andrew Shepard on 12/17/14.
//  Copyright (c) 2014 Andrew Shepard. All rights reserved.
//

import Foundation

extension URL {
    static var applicationDocumentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] 
    }
    
    static var temporaryDirectory: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
}
