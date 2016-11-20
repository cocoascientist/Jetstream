
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import CoreLocation
import JetstreamKit
import PocketSVG

class ViewController: UIViewController {
    fileprivate let weatherModel = WeatherModel()
    
    @IBOutlet var stackView: UIStackView!
    
    private lazy var forecastsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        for _ in 0...2 {
            let nib = Bundle.main.loadNibNamed(ForecastView.nibName, owner: self, options: nil)
            guard let forecastView = nib?.first as? ForecastView else { fatalError() }
            
            stackView.addArrangedSubview(forecastView)
        }
        
        return stackView
    }()
    
    private lazy var conditionsView: ConditionsView = {
        let nib = Bundle.main.loadNibNamed(ConditionsView.nibName, owner: self, options: nil)
        guard let conditionsView = nib?.first as? ConditionsView else { fatalError() }
        
        return conditionsView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        let heightRelation = NSLayoutConstraint(item: conditionsView, attribute: .height, relatedBy: .equal, toItem: forecastsStackView, attribute: .height, multiplier: 1.667, constant: 0)
        
        self.stackView.addArrangedSubview(conditionsView)
        self.stackView.addArrangedSubview(forecastsStackView)
        
        self.stackView.addConstraint(heightRelation)
    }
}

extension ViewController {
    internal func didReceiveError(notification: Notification) -> Void {
        print("error: \(notification)")
    }
    
    internal func didReceiveUpdate(notification: Notification) -> Void {
        self.updateConditionsViewModel()
    }
    
    internal func updateConditionsViewModel() -> Void {
        let result = self.weatherModel.currentWeather
        
        switch result {
        case .success(let weather):
//            let viewModel = WeatherViewModel(weather: weather)
//            self.headerView.viewModel = viewModel
            print("update weather: \(weather)")
        case .failure:
            print("error updating view model, no data")
        }
    }
}
