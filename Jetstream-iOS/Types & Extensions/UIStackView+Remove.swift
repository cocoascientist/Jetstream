//
//  UIStackView+Remove.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/7/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit

extension UIStackView {
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { (subview) in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
