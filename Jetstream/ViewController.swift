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
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!

    private let weatherModel = WeatherModel()
    
    private lazy var dataSource: ForecastsDataSource = {
        return ForecastsDataSource(model: self.weatherModel)
    }()
    
    private lazy var headerView: ConditionsHeaderView? = {
        return NSBundle.mainBundle().loadNibNamed(ConditionsHeaderView.nibName, owner: self, options: nil).first as? ConditionsHeaderView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "background.jpg") {
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
            self.imageView.image = image
        }
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        self.tableView.pagingEnabled = true
        self.tableView.rowHeight = 44.0
        
        self.dataSource.tableView = self.tableView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "conditionsDidUpdate:", name: ConditionsDidUpdateNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveError:", name: WeatherModelDidReceiveErrorNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if let headerView = self.headerView {
            headerView.frame = UIScreen.mainScreen().bounds
            self.headerView = headerView
            self.tableView.tableHeaderView = headerView
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - Private
    
    func didReceiveError(notification: NSNotification) -> Void {
        println("error notification: \(notification.userInfo)")
    }

    func conditionsDidUpdate(notification: NSNotification) -> Void {
        self.updateConditionsViewModel()
    }
    
    func updateConditionsViewModel() -> Void {
        let result = self.weatherModel.currentWeather
        switch result {
        case .Success(let weather):
            let viewModel = WeatherViewModel(weather: weather.unbox)
            self.headerView?.viewModel = viewModel
        case .Failure(let reason):
            println("error updating view model, no data")
        }
    }
}
