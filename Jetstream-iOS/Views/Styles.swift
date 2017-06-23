//
//  Styles.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/19/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit

public let blueColor = UIColor.hexColor("#0998DC")

public func createCaption1Label() -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.textColor = .white
    return label
}

public func createCaption2Label() -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .caption2)
    label.textColor = .white
    return label
}
