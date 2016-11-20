//
//  ForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/17/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit

class ForecastView: UIView {
    
    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var conditionsLabel: UILabel!
    @IBOutlet var highTemperatureLabel: UILabel!
    @IBOutlet var lowTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let font = UIFont(name: "Weather Icons", size: 40.0)
        self.conditionsLabel.font = font
        self.conditionsLabel.text = "\u{f01d}"
    }
}
