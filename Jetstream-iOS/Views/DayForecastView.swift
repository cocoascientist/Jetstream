//
//  DayForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

private func createDefaultLabel() -> UILabel {
    let label = createBlankLabel()
    label.font = UIFont.preferredFont(forTextStyle: .callout)
    return label
}

final class DayForecastView: UIView {
    
    // FIXME: viewmodel
    
    public lazy var dayLabel: UILabel = {
        return createDefaultLabel()
    }()
    
    public lazy var highTemperatureLabel: UILabel = {
        return createDefaultLabel()
    }()
    
    public lazy var lowTemperatureLabel: UILabel = {
        return createDefaultLabel()
    }()
    
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
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            iconLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            iconLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            highTemperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            highTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            highTemperatureLabel.trailingAnchor.constraint(equalTo: lowTemperatureLabel.leadingAnchor, constant: -16),
            
            lowTemperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            lowTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            lowTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
