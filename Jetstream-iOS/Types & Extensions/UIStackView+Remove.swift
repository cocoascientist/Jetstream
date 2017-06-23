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
        self.arrangedSubviews.forEach { (subview) in
            self.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
