//
//  DayForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class DayForecastView: UIView {
    
    // FIXME: viewmodel
    
    public lazy var dayLabel: UILabel = {
        return createCaption1Label()
    }()
    
    public lazy var highTemperatureLabel: UILabel = {
        return createCaption1Label()
    }()
    
    public lazy var lowTemperatureLabel: UILabel = {
        return createCaption1Label()
    }()
    
    public lazy var iconLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Weather Icons", size: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViewHierarchy()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func layoutViewHierarchy() {
        addSubview(dayLabel)
        addSubview(iconLabel)
        addSubview(highTemperatureLabel)
        addSubview(lowTemperatureLabel)
    }

    private func applyConstraints() {
        applyDayLabelConstraints()
        applyIconConstraints()
        applyHighTemperatureLabelConstraints()
        applyLowTemperatureLabelConstraints()
    }
    
    private func applyDayLabelConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: dayLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16)
        let bottom = NSLayoutConstraint(item: dayLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let top = NSLayoutConstraint(item: dayLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        
        NSLayoutConstraint.activate([leading, top, bottom])
    }
    
    private func applyIconConstraints() {
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let center = NSLayoutConstraint(item: iconLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: iconLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let top = NSLayoutConstraint(item: iconLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        
        NSLayoutConstraint.activate([center, top, bottom])
    }
    
    private func applyHighTemperatureLabelConstraints() {
        highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: highTemperatureLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        let bottom = NSLayoutConstraint(item: highTemperatureLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let trailing = NSLayoutConstraint(item: highTemperatureLabel, attribute: .trailing, relatedBy: .equal, toItem: lowTemperatureLabel, attribute: .leading, multiplier: 1, constant: -16)
        
        NSLayoutConstraint.activate([top, bottom, trailing])
    }
    
    private func applyLowTemperatureLabelConstraints() {
        lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6)
        let bottom = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -6)
        let trailing = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
        
        NSLayoutConstraint.activate([top, bottom, trailing])
    }
}
