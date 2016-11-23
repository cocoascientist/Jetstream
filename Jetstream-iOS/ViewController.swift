
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

import JetstreamKit
import PocketSVG

class ViewController: UIViewController {
    var weatherModel: WeatherModel! = nil
    
    @IBOutlet var stackView: UIStackView!
    
//    fileprivate lazy var forecastsStackView: UIStackView = {
//        let stackView = UIStackView()
//        
//        
//        for _ in 0...2 {
//            let nib = Bundle.main.loadNibNamed(ForecastView.nibName, owner: self, options: nil)
//            guard let forecastView = nib?.first as? ForecastView else { fatalError() }
//            
//            stackView.addArrangedSubview(forecastView)
//        }
//        
//        return stackView
//    }()
    
    fileprivate lazy var forecastsView: ForecastsView = {
        let view = ForecastsView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var conditionsView: ConditionsView = {
        let nib = Bundle.main.loadNibNamed(ConditionsView.nibName, owner: self, options: nil)
        guard let conditionsView = nib?.first as? ConditionsView else { fatalError() }
        
        return conditionsView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        conditionsView.isHidden = true
        forecastsView.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        let heightRelation = NSLayoutConstraint(item: conditionsView, attribute: .height, relatedBy: .equal, toItem: forecastsView, attribute: .height, multiplier: 1.667, constant: 0)
        
        self.stackView.addArrangedSubview(conditionsView)
        self.stackView.addArrangedSubview(forecastsView)
        
        self.stackView.addConstraint(heightRelation)
        
        self.weatherModel.loadInitialModel { [weak self] error in
            print("done loading model")
            
            self?.update()
        }
    }
}

extension ViewController {
    internal func didReceiveError(notification: Notification) -> Void {
        print("error: \(notification)")
    }
    
    internal func didReceiveUpdate(notification: Notification) -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.update()
        }
    }
    
    internal func update() -> Void {
        let result = self.weatherModel.currentWeather()
        
        switch result {
        case .success(let weather):
            print("updating view...")
            
            let conditionsViewModel = ConditionsViewModel(weather: weather)
            updateConditions(with: conditionsViewModel)
            
            let forecastsViewModel = ForecastsViewModel(weather: weather)
            updateForecasts(with: forecastsViewModel)
        case .failure:
            print("error updating view model, no data")
        }
    }
    
    internal func updateConditions(with viewModel: ConditionsViewModel) {
        self.conditionsView.viewModel = viewModel
        
        self.conditionsView.isHidden = false
    }
    
    internal func updateForecasts(with viewModel: ForecastsViewModel) {
        self.forecastsView.viewModel = viewModel
        
        self.forecastsView.isHidden = false
    }
}
