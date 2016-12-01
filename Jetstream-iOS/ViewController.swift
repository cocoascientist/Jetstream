
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class ViewController: UIViewController {
    var weatherModel: WeatherModel! = nil
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    
    fileprivate lazy var forecastsView: ForecastsView = {
        let view = ForecastsView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var conditionsView: ConditionsView = {
        let nib = Bundle.main.loadNibNamed(ConditionsView.nibName, owner: self, options: nil)
        guard let conditionsView = nib?.first as? ConditionsView else { fatalError() }
        
        return conditionsView
    }()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl(frame: .zero)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(ViewController.shouldTriggerRefresh), for: .valueChanged)
        
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        configureAndApplyConstraints()
        listenForNotifications()
        
        self.weatherModel.loadInitialModel { [weak self] error in
            self?.reload()
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
            self?.reload()
        }
    }
    
    internal func shouldTriggerRefresh() -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.update()
            self?.refreshControl.endRefreshing()
        }
    }
    
    internal func update() {
        self.weatherModel.updateWeatherForCurrentLocation()
    }
    
    internal func reload() {
        let result = self.weatherModel.currentWeather()
        
        switch result {
        case .success(let weather):
            let conditionsViewModel = ConditionsViewModel(weather: weather)
            updateConditions(with: conditionsViewModel)
            
            let forecastsViewModel = ForecastsViewModel(weather: weather)
            updateForecasts(with: forecastsViewModel)
        case .failure(let error):
            print("error updating view model: \(error)")
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

extension ViewController {
    fileprivate func setupViewHierarchy() {
        self.view.backgroundColor = UIColor.white
        
        self.scrollView.addSubview(refreshControl)
        self.stackView.addArrangedSubview(conditionsView)
        self.stackView.addArrangedSubview(forecastsView)
        
        conditionsView.isHidden = true
        forecastsView.isHidden = false
    }
    
    fileprivate func configureAndApplyConstraints() {
        let heightRelation = NSLayoutConstraint(item: conditionsView, attribute: .height, relatedBy: .equal, toItem: forecastsView, attribute: .height, multiplier: 1.667, constant: 0)
        let topConstraint = NSLayoutConstraint(item: refreshControl, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50)
        let centerConstraint = NSLayoutConstraint(item: refreshControl, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        heightRelation.isActive = true
        topConstraint.isActive = true
        centerConstraint.isActive = true
    }
    
    fileprivate func listenForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.update), name: UserDefaults.didChangeNotification, object: nil)
    }
}
