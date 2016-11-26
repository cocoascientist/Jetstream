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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
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
            guard let model = representedObject as? WeatherModel else { return }
            
            model.loadInitialModel { [weak self] (error) in
                print("model loaded")
                
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
        print("update conditions")
    }
    
    internal func updateForecasts(with viewModel: ForecastsViewModel) {
        print("update forecasts")
    }
    
    internal func configureAndApplyConstraints() {
        let views = ["stackView": stackView]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]-0-|", options: [], metrics: nil, views: views)
        
        self.view.addConstraints(vertical)
        self.view.addConstraints(horizontal)
    }
}
