//
//  ConditionsViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import CoreLocation

class ConditionsViewController: UIViewController {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var conditionsLabel: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var effectView: UIVisualEffectView?
    var headerView: ConditionsHeaderView?
    
    let dataSource = ForecastsDataSource()
    var weatherModel: WeatherModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        self.tableView.pagingEnabled = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.effectView = UIVisualEffectView(effect: blurEffect)
//        self.effectView?.alpha = 0.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "weatherDidUpdate:", name: WeatherDidUpdateNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = UIImage(named: "placeholder.jpg") {
            self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
            self.backgroundImageView.image = image
            
            effectView?.frame = self.backgroundImageView.bounds
            self.backgroundImageView.addSubview(effectView!)
        }
        
        // configure table view
        self.dataSource.tableView = self.tableView
        self.tableView.dataSource = self.dataSource
        
        self.weatherModel = WeatherModel()
    }
    
    override func viewDidLayoutSubviews() {
        if let headerView = NSBundle.mainBundle().loadNibNamed("ConditionsHeaderView", owner: self, options: nil).first as? ConditionsHeaderView {
            headerView.frame = UIScreen.mainScreen().bounds
            self.headerView = headerView
            self.tableView.tableHeaderView = headerView
        }
    }

    func weatherDidUpdate(notification: NSNotification) -> Void {
        self.updateWeatherViewModel()
    }
    
    func updateWeatherViewModel() -> Void {
        let result = self.weatherModel.currentWeather()
        switch result {
        case .Success(let weather):
            let viewModel = ConditionsViewModel(weather: weather())
            self.headerView?.viewModel = viewModel
            println("view model updated!")
        case .Failure(let reason):
            println("error updating view model, no data")
        }
    }
}
