//
//  ForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/27/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ForecastView: NSView {
    let stackView: NSStackView
    
    var viewModel: ForecastViewModel! {
        didSet {
            self.dayOfWeekLabel.stringValue = viewModel.dayOfWeek
            self.weatherIconLabel.stringValue = viewModel.weatherIcon
            self.highTemperatureLabel.stringValue = viewModel.highTemp
            self.lowTemperatureLabel.stringValue = viewModel.lowTemp
        }
    }
    
    lazy var dayOfWeekLabel: NSTextField = {
        let label = NSTextField.defaultStyle
        return label
    }()
    
    lazy var weatherIconLabel: NSTextField = {
        let label = NSTextField.defaultStyle
        label.font = NSFont(name: "Weather Icons", size: 36.0)
        
        return label
    }()
    
    lazy var highTemperatureLabel: NSTextField = {
        let label = NSTextField.defaultStyle
        return label
    }()
    
    lazy var lowTemperatureLabel: NSTextField = {
        let label = NSTextField.defaultStyle
        return label
    }()
    
    override init(frame frameRect: NSRect) {
        self.stackView = NSStackView(frame: .zero)
        super.init(frame: frameRect)
        
        self.addSubview(stackView)
        
        configureStackView()
        configureAndApplyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ForecastView {
    internal func configureStackView() {
        stackView.orientation = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .centerX
        stackView.spacing = 20
        
        stackView.addArrangedSubview(self.dayOfWeekLabel)
        stackView.addArrangedSubview(self.weatherIconLabel)
        stackView.addArrangedSubview(self.highTemperatureLabel)
        stackView.addArrangedSubview(self.lowTemperatureLabel)
    }
    
    internal func configureAndApplyConstraints() {
        let views = ["stackView": stackView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[stackView]-|", options: [], metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stackView]-|", options: [], metrics: nil, views: views)
        
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

internal extension NSTextField {
    class var defaultStyle: NSTextField {
        let label = NSTextField(frame: .zero)
        
        label.isBezeled = false
        label.isEditable = false
        label.backgroundColor = .clear
        label.alignment = .center
        
        return label
    }
}
