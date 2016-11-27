//
//  ForecastViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/8/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ForecastsViewController: NSViewController {
    
    @IBOutlet var stackView: NSStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            guard let model = representedObject as? ForecastsViewModel else { return }
            
            stackView.removeArrangedSubviews()
            
            for viewModel in model.forecasts {
                let forecastView = ForecastView(frame: .zero)
                forecastView.viewModel = viewModel
                
                stackView.addArrangedSubview(forecastView)
            }
        }
    }
}

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
        let label = NSTextField(frame: .zero)
        
        label.isBezeled = false
        label.backgroundColor = .clear
        label.alignment = .center
        
        return label
    }()
    
    lazy var weatherIconLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        
        label.isBezeled = false
        label.backgroundColor = .clear
        label.alignment = .center
        label.font = NSFont(name: "Weather Icons", size: 36.0)
        
        return label
    }()
    
    lazy var highTemperatureLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        
        label.isBezeled = false
        label.backgroundColor = .clear
        label.alignment = .center
        
        return label
    }()
    
    lazy var lowTemperatureLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        
        label.isBezeled = false
        label.backgroundColor = .clear
        label.alignment = .center
        
        return label
    }()
    
    override init(frame frameRect: NSRect) {
        self.stackView = NSStackView(frame: .zero)
        super.init(frame: frameRect)
        
        self.addSubview(stackView)
        
        stackView.orientation = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .centerX
        stackView.spacing = 20
        
        let views = ["stackView": stackView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[stackView]-|", options: [], metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stackView]-|", options: [], metrics: nil, views: views)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
        
        stackView.addArrangedSubview(self.dayOfWeekLabel)
        stackView.addArrangedSubview(self.weatherIconLabel)
        stackView.addArrangedSubview(self.highTemperatureLabel)
        stackView.addArrangedSubview(self.lowTemperatureLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension NSStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
