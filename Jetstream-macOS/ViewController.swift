//
//  ViewController.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/3/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ViewController: NSViewController {
    
    lazy var stackView: NSStackView = {
        
        let forecastView = self.forecastViewController.view
        let conditionsView = self.conditionsViewController.view
        
        let stackView = NSStackView(views: [conditionsView, forecastView])
        
        stackView.distribution = .fillEqually
        stackView.orientation = .vertical
        
        return stackView
    }()
    
    lazy var forecastViewController: ForecastsViewController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateController(withIdentifier: "ForecastsViewController") as? ForecastsViewController else {
            fatalError("missing controller")
        }
        
        return controller
    }()
    
    lazy var conditionsViewController: ConditionsViewController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateController(withIdentifier: "ConditionsViewController") as? ConditionsViewController else {
            fatalError("missing controller")
        }
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        view.addSubview(self.stackView)
        
        configureAndApplyConstraints()
        
        addChildViewController(conditionsViewController)
        addChildViewController(forecastViewController)
    }

    override var representedObject: Any? {
        didSet {
            guard let model = representedObject as? WeatherModel else { return }
            
            model.loadInitialModel { [weak self] (error) in
                self?.update()
            }
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
        guard let weatherModel = representedObject as? WeatherModel else { return }
        let result = weatherModel.currentWeather()
        
        switch result {
        case .success(let weather):
            let conditionsViewModel = ConditionsViewModel(weather: weather)
            updateConditions(with: conditionsViewModel)
            
            let forecastsViewModel = ForecastsViewModel(weather: weather)
            updateForecasts(with: forecastsViewModel)
        case .failure:
            print("error updating view model, no data")
        }
    }
    
    internal func updateConditions(with viewModel: ConditionsViewModel) {
        self.conditionsViewController.representedObject = viewModel
    }
    
    internal func updateForecasts(with viewModel: ForecastsViewModel) {
        self.forecastViewController.representedObject = viewModel
    }
    
    internal func configureAndApplyConstraints() {
        let views = ["stackView": stackView]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        
        self.view.addConstraints(vertical)
        self.view.addConstraints(horizontal)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}
