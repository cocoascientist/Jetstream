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
        let nib = Bundle.main.loadNibNamed(ConditionsHeaderView.nibName, owner: self, options: nil)
        if let headerView = nib?.first as? ConditionsHeaderView {
            headerView.frame = UIScreen.main.bounds
            return headerView
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "background.jpg") {
            self.imageView.contentMode = UIViewContentMode.scaleAspectFill
            self.imageView.image = image
        }
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor = UIColor.white.withAlphaComponent(0.4)
        self.tableView.isPagingEnabled = true
        self.tableView.rowHeight = 44.0
        
        // configure the forecasts data source with a table
        self.dataSource.tableView = self.tableView
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.conditionsDidUpdate(_:)), name: NSNotification.Name.ConditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError(_:)), name: NSNotification.Name.WeatherModelDidReceiveError, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView = self.headerView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Private
    
    func didReceiveError(_ notification: Notification) -> Void {
        // TODO: add end user error handling
        print("erro: \(notification)")
    }

    func conditionsDidUpdate(_ notification: Notification) -> Void {
        self.updateConditionsViewModel()
    }
    
    func updateConditionsViewModel() -> Void {
        let result = self.weatherModel.currentWeather
        
        switch result {
        case .success(let weather):
            let viewModel = WeatherViewModel(weather: weather)
            self.headerView?.viewModel = viewModel
        case .failure:
            print("error updating view model, no data")
        }
    }
}
