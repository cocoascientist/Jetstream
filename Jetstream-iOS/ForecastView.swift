//
//  ForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/17/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class ForecastsView: UIView {
    private let stackView: UIStackView
    
    var viewModel: ForecastsViewModel! {
        didSet {
            stackView.removeArrangedSubviews()
            
            viewModel.forecasts.forEach { model in
                let nib = Bundle.main.loadNibNamed(ForecastView.nibName, owner: self, options: nil)
                guard let forecastView = nib?.first as? ForecastView else { fatalError() }
                
                forecastView.viewModel = model
                stackView.addArrangedSubview(forecastView)
            }
        }
    }
    
    override init(frame: CGRect) {
        self.stackView = UIStackView(frame: frame)
        super.init(frame: frame)
        
        self.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["stackView": stackView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class ForecastView: UIView {
    
    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var weatherIconLabel: UILabel!
    @IBOutlet var highTemperatureLabel: UILabel!
    @IBOutlet var lowTemperatureLabel: UILabel!
    
    var viewModel: ForecastViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.dayOfWeekLabel.text = viewModel.dayOfWeek
            self.weatherIconLabel.text = viewModel.weatherIcon
            self.lowTemperatureLabel.text = viewModel.lowTemp
            self.highTemperatureLabel.text = viewModel.highTemp
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dayOfWeekLabel.text = ""
        self.weatherIconLabel.text = ""
        self.highTemperatureLabel.text = ""
        self.lowTemperatureLabel.text = ""
        
        let font = UIFont(name: "Weather Icons", size: 22.0)
        self.weatherIconLabel.font = font
    }
}

extension UIStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
