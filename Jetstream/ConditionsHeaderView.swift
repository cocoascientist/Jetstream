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
    
    class var nibName: String {
        return "ConditionsHeaderView"
    }
    
    var viewModel: WeatherViewModel! {
        didSet {
            self.cityNameLabel.text = viewModel.cityName
            self.conditionsLabel.text = viewModel.currentConditions
            
            self.temperatureLabel.text = viewModel.currentTemperature
            self.temperatureRangeLabel.text = viewModel.temperatureRange
        }
    }
    
    override func awakeFromNib() {
        self.cityNameLabel.text = ""
        self.conditionsLabel.text = ""
        self.temperatureLabel.text = ""
        self.temperatureRangeLabel.text = ""
        
        self.temperatureLabel.textColor = UIColor.whiteColor()
        self.temperatureRangeLabel.textColor = UIColor.whiteColor()
        
        let font = UIFont(name: "Weather Icons", size: 40.0)
        self.conditionsLabel.font = font
        self.conditionsLabel.textColor = UIColor.whiteColor()
        self.cityNameLabel.textColor = UIColor.whiteColor()
    }
 
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clearColor()
    }
}