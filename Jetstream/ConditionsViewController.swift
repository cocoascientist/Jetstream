//
//  ConditionsViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import CoreLocation

class ConditionsViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    private var effectView: UIVisualEffectView?
    private var headerView: ConditionsHeaderView?
    
    private var dataSource: ForecastsDataSource!
    private var conditionsModel: ConditionsModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        self.tableView.pagingEnabled = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.effectView = UIVisualEffectView(effect: blurEffect)
        self.effectView?.alpha = 0.1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "weatherDidUpdate:", name: WeatherDidUpdateNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveError:", name: ConditionsModelDidReceiveErrorNotification, object: nil)
        
        self.conditionsModel = ConditionsModel()
        self.dataSource = ForecastsDataSource(model: conditionsModel)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = UIImage(named: "background.jpg") {
            self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
            self.backgroundImageView.image = image
            
            effectView?.frame = self.backgroundImageView.bounds
            self.backgroundImageView.addSubview(effectView!)
        }
        
        // configure table view
        self.dataSource.tableView = self.tableView
        self.tableView.dataSource = self.dataSource
        
        self.tableView.delegate = self
        self.tableView.rowHeight = 44
    }
    
    override func viewDidLayoutSubviews() {
        if let headerView = NSBundle.mainBundle().loadNibNamed("ConditionsHeaderView", owner: self, options: nil).first as? ConditionsHeaderView {
            headerView.frame = UIScreen.mainScreen().bounds
            self.headerView = headerView
            self.tableView.tableHeaderView = headerView
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height = scrollView.bounds.size.height
        let position = max(scrollView.contentOffset.y, 0.0)
        let percent = min(position / height, 1.0)
        self.effectView?.alpha = percent
    }
    
    // MARK: - Private
    
    func didReceiveError(notification: NSNotification) -> Void {
        println("error notification: \(notification.userInfo)")
    }

    func weatherDidUpdate(notification: NSNotification) -> Void {
        self.updateWeatherViewModel()
    }
    
    func updateWeatherViewModel() -> Void {
        let result = self.conditionsModel.currentWeather()
        switch result {
        case .Success(let weather):
            let viewModel = ConditionsViewModel(weather: weather.unbox)
            self.headerView?.viewModel = viewModel
            println("view model updated!")
        case .Failure(let reason):
            println("error updating view model, no data")
        }
    }
}
