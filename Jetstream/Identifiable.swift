//
//  Identifiable.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/13/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit

protocol NIBIdentifiable {
    static var nibName: String { get }
}

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension UIView: NIBIdentifiable {
    static var nibName: String {
        return String(self)
    }
}

extension UITableViewCell: CellIdentifiable {
    static var cellIdentifier: String {
        return String(self)
    }
}