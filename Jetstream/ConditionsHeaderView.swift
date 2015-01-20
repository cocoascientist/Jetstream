//
//  ConditionsHeaderView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import UIKit

class ConditionsHeaderView: UIView {
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var temperatureRangeLabel: UILabel!
    
    var viewModel: ConditionsViewModel? {
        didSet {
            // TODO: implement
        }
    }
 
    override func layoutSubviews() {
        self.backgroundColor = UIColor.redColor()
        
        self.cityNameLabel.text = "TEST"
    }
}