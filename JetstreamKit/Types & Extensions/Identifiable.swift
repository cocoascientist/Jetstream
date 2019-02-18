//
//  Identifiable.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/13/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

#if os(iOS)
import UIKit
    
public protocol NIBIdentifiable {
    static var nibName: String { get }
}

extension UIView: NIBIdentifiable {
    public static var nibName: String {
        return String(describing: self)
    }
}
#endif
