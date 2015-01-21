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
    @IBOutlet var conditionsLabel: UILabel!
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var temperatureRangeLabel: UILabel!
    
    var weather: Weather? {
        didSet {
            self.cityNameLabel.text = weather?.name
            self.conditionsLabel.text = "\u{f00d} Sunny"
            
            self.temperatureLabel.text = "\(weather!.temperatures.currentTemp)°"
            
            let rangeString = "\(weather!.temperatures.maxTemp)° / \(weather!.temperatures.minTemp)°"
            self.temperatureRangeLabel.text = rangeString
        }
    }
    
    override func awakeFromNib() {
        self.cityNameLabel.text = ""
        self.temperatureLabel.text = ""
        self.temperatureRangeLabel.text = ""
        
        self.temperatureLabel.textColor = UIColor.whiteColor()
        self.temperatureRangeLabel.textColor = UIColor.whiteColor()
        
        let font = UIFont(name: "Weather Icons", size: 34.0)
        self.conditionsLabel.font = font
        self.conditionsLabel.textColor = UIColor.whiteColor()
//        self.cityNameLabel.textColor = UIColor.whiteColor()
    }
 
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clearColor()
    }
}