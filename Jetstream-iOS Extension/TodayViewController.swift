//
//  TodayViewController.swift
//  Jetstream-iOS Extension
//
//  Created by Andrew Shepard on 11/17/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit
import NotificationCenter
import JetstreamKit

internal typealias WidgetCompletion = (NCUpdateResult) -> Void

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var weatherIconLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var conditionsLabel: UILabel!
    
    fileprivate let dataController = CoreDataController()
    
    fileprivate lazy var weatherModel: WeatherModel = {
        let weatherModel = WeatherModel(dataController: self.dataController)
        return weatherModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.weatherIconLabel.font = UIFont(name: "Weather Icons", size: 36.0)
        
        self.weatherModel.loadInitialModel { [weak self] error in
            self?.update()
        }
    }
    
    func widgetPerformUpdate(completionHandler: @escaping WidgetCompletion) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        update(completion: completionHandler)
    }
}

extension TodayViewController {
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
        self.cityNameLabel.text = conditions.cityName
        self.conditionsLabel.text = conditions.summary
        self.weatherIconLabel.text = conditions.weatherIcon
    }
}
