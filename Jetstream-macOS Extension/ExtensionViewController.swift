//
//  TodayViewController.swift
//  Jetstream-macOS Extension
//
//  Created by Andrew Shepard on 11/17/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import NotificationCenter
import JetstreamKit

internal typealias WidgetCompletion = (NCUpdateResult) -> Void

class ExtensionViewController: NSViewController, NCWidgetProviding {
    
    @IBOutlet var weatherIconLabel: NSTextField!
    @IBOutlet var cityNameLabel: NSTextField!
    @IBOutlet var summaryLabel: NSTextField!
    
    fileprivate let dataController = CoreDataController()
    
    fileprivate lazy var weatherModel: WeatherModel = {
        let weatherModel = WeatherModel(dataController: self.dataController)
        return weatherModel
    }()

    override var nibName: String? {
        return "ExtensionViewController"
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
        update(completion: completionHandler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherModel.loadInitialModel { [weak self] error in
            self?.update()
        }
    }
}

extension ExtensionViewController {
    internal func update(completion: WidgetCompletion? = nil) -> Void {
        let result = self.weatherModel.currentWeather()
        
        switch result {
        case .success(let weather):
            print("should update with weather: \(weather)")
            let viewModel = ConditionsViewModel(weather: weather)
            update(with: viewModel)
            
            completion?(NCUpdateResult.newData)
        case .failure(let error):
            print("error updating view model: \(error)")
            completion?(NCUpdateResult.noData)
        }
    }
    
    internal func update(with conditions: ConditionsViewModel) -> Void {
        self.cityNameLabel.stringValue = conditions.cityName
        self.summaryLabel.stringValue = conditions.summary
        self.weatherIconLabel.stringValue = conditions.weatherIcon
    }
}
