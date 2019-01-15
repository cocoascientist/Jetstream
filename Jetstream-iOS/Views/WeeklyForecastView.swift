//
//  WeeklyForecastView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/18/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class WeeklyForecastView: UIView {
    
    private let stackView: UIStackView
    
    var viewModel: ForecastsViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            stackView.removeAllArrangedSubviews()
            addSubviewsToStackView()
        }
    }
    
    override init(frame: CGRect) {
        self.stackView = UIStackView(frame: frame)
        
        super.init(frame: frame)
        
        self.addSubview(stackView)
        
        configureStackView()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension WeeklyForecastView {
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addSubviewsToStackView() {
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
            
            widthConstraint.isActive = true
        }
    }
}
