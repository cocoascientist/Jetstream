//
//  WeeklyForecastViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class WeeklyForecastViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    
    var viewModel: ForecastsViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            stackView.removeAllArrangedSubviews()
            addSubviewsToStackView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.alignment = .center
        stackView.distribution = .fill

        // Do any additional setup after loading the view.
        
        addSubviewsToStackView()
    }
    
    fileprivate func addSubviewsToStackView() {
        guard let viewModel = viewModel else { return }
        guard viewModel.dailyForecasts.count > 1 else { return }
        
        let forecasts = viewModel.dailyForecasts[1..<viewModel.dailyForecasts.count]
        
        for forecast in forecasts {
            let dayForecastView = DayForecastView()
            
            dayForecastView.highTemperatureLabel.text = forecast.highTemp
            dayForecastView.lowTemperatureLabel.text = forecast.lowTemp
            dayForecastView.dayLabel.text = forecast.dayOfWeek
            dayForecastView.iconLabel.text = forecast.weatherIcon
            
            stackView.addArrangedSubview(dayForecastView)
            
            let widthConstraint = NSLayoutConstraint(item: dayForecastView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1, constant: 0)
            
            view.addConstraint(widthConstraint)
        }
    }
}
