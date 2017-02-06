//
//  HourlyCollectionViewCell.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/1/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    var viewModel: ForecastViewModel? {
        didSet {
            topLabel.text = viewModel?.hourOfDay
            iconLabel.text = viewModel?.weatherIcon
            bottomLabel.text = viewModel?.highTemp
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        topLabel.text = ""
        bottomLabel.text = ""
        iconLabel.text = ""
        
        iconLabel.font = UIFont(name: "Weather Icons", size: 22)
        iconLabel.text = "\u{f00d}"
    }
}
