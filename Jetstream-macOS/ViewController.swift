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
    fileprivate var weatherModel: WeatherModel?
    
    @IBOutlet weak var locationLabel: NSTextField!
    @IBOutlet weak var conditionsLabel: NSTextField!
    @IBOutlet weak var conditionsIconLabel: NSTextField!
    @IBOutlet weak var temperatureLabel: NSTextField!
    
    @IBOutlet weak var windIconLabel: NSTextField!
    @IBOutlet weak var windDirectionIconLabel: NSTextField!
    
    @IBOutlet weak var windSpeedLabel: NSTextField!
    @IBOutlet weak var windDirectionLabel: NSTextField!
    
    lazy var stackView: NSStackView = {
        
//        let forecastView = self.forecastViewController.view
        let conditionsView = self.conditionsViewController.view
        
        let stackView = NSStackView(views: [conditionsView])
        
        stackView.distribution = .fillEqually
        stackView.orientation = .vertical
        
        return stackView
    }()
    
    lazy var forecastViewController: ForecastViewController = {
        let storyboard = NSStoryboard(name: "Forecast", bundle: nil)
        guard let controller = storyboard.instantiateInitialController() as? ForecastViewController else {
            fatalError("missing controller")
        }
        
        return controller
    }()
    
    lazy var conditionsViewController: NSViewController = {
        let storyboard = NSStoryboard(name: "Conditions", bundle: nil)
        guard let controller = storyboard.instantiateInitialController() as? NSViewController else {
            fatalError("missing controller")
        }
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.conditionsDidUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.forecastsDidUpdate), name: .forecastDidUpdate, object: nil)
        
        self.weatherModel = WeatherModel()
        
//        conditionsIconLabel.font = NSFont(name: "Weather Icons", size: 42.0)
//        windIconLabel.font = NSFont(name: "Weather Icons", size: 36.0)
//        windDirectionIconLabel.font = NSFont(name: "Weather Icons", size: 36.0)
//        
//        locationLabel.stringValue = ""
//        conditionsLabel.stringValue = ""
//        conditionsIconLabel.stringValue = ""
//        temperatureLabel.stringValue = ""
//        
//        windIconLabel.stringValue = "\u{f050}"
//        windDirectionIconLabel.stringValue = "\u{f0b1}"
        
        view.addSubview(self.stackView)
        
        configureAndApplyConstraints()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController {
    internal func didReceiveError(notification: Notification) -> Void {
        print("error: \(notification)")
    }
    
    internal func conditionsDidUpdate(with notification: Notification) -> Void {
        self.updateConditions()
    }
    
    internal func forecastsDidUpdate(with notification: Notification) -> Void {
        self.updateForecasts()
    }
    
    internal func updateConditions() -> Void {
        guard let result = self.weatherModel?.currentWeather else { return }
        
        switch result {
        case .success(let weather):
//            print("update weather: \(weather)")
            updateConditions(with: weather)
        case .failure(let error):
            print("error updating weather: \(error)")
        }
    }
    
    internal func updateConditions(with weather: Weather) {
        let viewModel = WeatherViewModel(weather: weather)
        
//        locationLabel.stringValue = viewModel.cityName
//        conditionsLabel.stringValue = viewModel.currentConditions
//        conditionsIconLabel.stringValue = viewModel.weatherIcon
//        temperatureLabel.stringValue = viewModel.currentTemperature
//        
//        windSpeedLabel.stringValue = viewModel.windSpeed
//        windDirectionLabel.stringValue = viewModel.windBearing
    }
    
    internal func updateForecasts() -> Void {
        guard let result = self.weatherModel?.currentForecast else { return }
        
        switch result {
        case .success(let forecasts):
            print("update forecasts: \(forecasts)")
            self.forecastViewController.updateForecast(with: forecasts)
        case .failure(let error):
            print("error updating forecasts: \(error)")
        }
    }
    
    internal func configureAndApplyConstraints() {
        let views = ["stackView": stackView]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        
        self.view.addConstraints(vertical)
        self.view.addConstraints(horizontal)
    }
}
