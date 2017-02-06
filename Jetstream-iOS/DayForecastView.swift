//
//  DayForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class DayForecastView: UIView {
    
    let dayLabel: UILabel
    let iconLabel: UILabel
    let highTemperatureLabel: UILabel
    let lowTemperatureLabel: UILabel
    
    override init(frame: CGRect) {
        self.dayLabel = UILabel(frame: .zero)
        self.iconLabel = UILabel(frame: .zero)
        self.highTemperatureLabel = UILabel(frame: .zero)
        self.lowTemperatureLabel = UILabel(frame: .zero)
        
        super.init(frame: frame)
        
        self.addSubview(dayLabel)
        self.addSubview(iconLabel)
        self.addSubview(highTemperatureLabel)
        self.addSubview(lowTemperatureLabel)
        
        dayLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        highTemperatureLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        lowTemperatureLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        
        iconLabel.font = UIFont(name: "Weather Icons", size: 13)
        
        dayLabel.text = "Testing"
        iconLabel.text = "\u{f00d}"
        highTemperatureLabel.text = "59"
        lowTemperatureLabel.text = "40"
        
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func applyConstraints() {
        applyDayLabelConstraints()
        applyIconConstraints()
        applyHighTemperatureLabelConstraints()
        applyLowTemperatureLabelConstraints()
    }
    
    func applyDayLabelConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: dayLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16)
        let bottom = NSLayoutConstraint(item: dayLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let top = NSLayoutConstraint(item: dayLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        
        self.addConstraint(leading)
        self.addConstraint(bottom)
        self.addConstraint(top)
    }
    
    func applyIconConstraints() {
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let center = NSLayoutConstraint(item: iconLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: iconLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let top = NSLayoutConstraint(item: iconLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        
        self.addConstraint(center)
        self.addConstraint(top)
        self.addConstraint(bottom)
    }
    
    func applyHighTemperatureLabelConstraints() {
        highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: highTemperatureLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        let bottom = NSLayoutConstraint(item: highTemperatureLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let trailing = NSLayoutConstraint(item: highTemperatureLabel, attribute: .trailing, relatedBy: .equal, toItem: lowTemperatureLabel, attribute: .leading, multiplier: 1, constant: -16)
        
        let constraints = [top, bottom, trailing]
        self.addConstraints(constraints)
    }
    
    func applyLowTemperatureLabelConstraints() {
        lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        let bottom = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let trailing = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
        
        let constraints = [top, bottom, trailing]
        self.addConstraints(constraints)
    }
}
