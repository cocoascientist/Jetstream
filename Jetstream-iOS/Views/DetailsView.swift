//
//  DetailsView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/16/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class DetailsView: UIView {
    
    var conditionsViewModel: ConditionsViewModel? {
        didSet {
            guard let viewModel = conditionsViewModel else { return }
            
            summaryView.viewModel = viewModel
            dataPointsView.viewModel = viewModel.dataPointsViewModel
        }
    }
    
    var forecastsViewModel: ForecastsViewModel? {
        didSet {
            guard let viewModel = forecastsViewModel else { return }
            
            weeklyForecastView.viewModel = viewModel
        }
    }

    lazy var weeklyForecastView: WeeklyForecastView = {
        let view = WeeklyForecastView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var summaryView: SummaryView = {
        let view = SummaryView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dataPointsView: DataPointsView = {
        let view = DataPointsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topConstraintToClippingView: NSLayoutConstraint = {
        return weeklyForecastView.topAnchor.constraint(equalTo: topAnchor)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        addSubview(weeklyForecastView)
        addSubview(summaryView)
        addSubview(dataPointsView)
        
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func adjustAppearence(using offset: CGPoint) {
        if offset.y > Size.temperatureViewMaxContentOffset {
            let delta = offset.y - Size.temperatureViewMaxContentOffset
            topConstraintToClippingView.constant = -delta
        } else {
            topConstraintToClippingView.constant = 0
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            weeklyForecastView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weeklyForecastView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topConstraintToClippingView,
            
            summaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryView.topAnchor.constraint(equalTo: weeklyForecastView.bottomAnchor),
            
            dataPointsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dataPointsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dataPointsView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            dataPointsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
