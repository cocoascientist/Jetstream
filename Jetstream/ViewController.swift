//
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    fileprivate let weatherModel = WeatherModel()
    
    fileprivate lazy var dataSource: ForecastsDataSource = {
        return ForecastsDataSource(model: self.weatherModel)
    }()
    
    fileprivate lazy var headerView: ConditionsHeaderView = {
        let nib = Bundle.main.loadNibNamed(ConditionsHeaderView.nibName, owner: self, options: nil)
        guard let headerView = nib?.first as? ConditionsHeaderView else {
            fatalError("missing header view")
        }
        
        headerView.frame = UIScreen.main.bounds
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
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
            print("update weather!")
        case .failure:
            print("error updating view model, no data")
        }
    }
}
