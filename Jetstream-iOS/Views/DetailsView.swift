//
//  DetailsView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/16/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class DetailsView: UIView {
    
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
        let top = NSLayoutConstraint(item: self.weeklyForecastView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        return top
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        self.addSubview(weeklyForecastView)
        self.addSubview(summaryView)
        self.addSubview(dataPointsView)
        
        applyWeeklyForecastViewConstraints()
        applySummaryViewConstraints()
        applyDataPointsViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func adjustAppearence(using offset: CGPoint) {
        if offset.y > 170 {
            let delta = offset.y - 170
            topConstraintToClippingView.constant = -delta
        }
        else {
            topConstraintToClippingView.constant = 0
        }
    }

    private func applyWeeklyForecastViewConstraints() {
        let leading = NSLayoutConstraint(item: weeklyForecastView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: weeklyForecastView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = self.topConstraintToClippingView
        
        NSLayoutConstraint.activate([leading, trailing, top])
    }
    
    private func applySummaryViewConstraints() {
        let leading = NSLayoutConstraint(item: summaryView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: summaryView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: summaryView, attribute: .top, relatedBy: .equal, toItem: weeklyForecastView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leading, trailing, top])
    }
    
    private func applyDataPointsViewConstraints() {
        let leading = NSLayoutConstraint(item: dataPointsView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: dataPointsView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: dataPointsView, attribute: .top, relatedBy: .equal, toItem: summaryView, attribute: .bottom, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: dataPointsView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}
