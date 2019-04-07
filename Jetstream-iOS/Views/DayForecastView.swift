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
    
    public lazy var dayLabel = createDefaultLabel()
    public lazy var highTemperatureLabel = createDefaultLabel()
    public lazy var lowTemperatureLabel = createDefaultLabel()
    
    public lazy var iconLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Weather Icons", size: 16)
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
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            dayLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            iconLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            iconLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            highTemperatureLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            highTemperatureLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            highTemperatureLabel.trailingAnchor.constraint(equalTo: lowTemperatureLabel.leadingAnchor, constant: -10),

            lowTemperatureLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            lowTemperatureLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            lowTemperatureLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
}
