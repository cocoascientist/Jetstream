//
//  ForecastsDataSource.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ForecastsDataSource: NSObject {
    private var forecasts: [Forecast] = []
    private let conditionsModel: WeatherModel
    
    weak var tableView: UITableView? {
        didSet {
            let nib = UINib(nibName: ForecastTableViewCell.nibName, bundle: nil)
            self.tableView?.registerNib(nib, forCellReuseIdentifier: ForecastTableViewCell.cellIdentifier)
            
            self.tableView?.dataSource = self
            self.tableView?.reloadData()
        }
    }
    
    init(model: WeatherModel) {
        self.conditionsModel = model
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ForecastsDataSource.forecastsDidUpdate(_:)), name: ForecastDidUpdateNotification, object: nil)
    }
    
    func forecastsDidUpdate(notification: NSNotification) -> Void {
        let result = self.conditionsModel.currentForecast
        switch result {
        case .Success(let forecasts):
            self.forecasts = forecasts
            self.tableView?.reloadData()
        case .Failure:
            print("error updating forecasts, no data")
        }
    }
    
    // MARK: - Private
    
    private func viewModelForIndexPath(indexPath: NSIndexPath) -> ForecastViewModel {
        let forecast = self.forecasts[indexPath.row] as Forecast
        let viewModel = ForecastViewModel(forecast: forecast)
        return viewModel
    }
}

extension ForecastsDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecasts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(ForecastTableViewCell.cellIdentifier, forIndexPath: indexPath) as? ForecastTableViewCell else {
            fatalError("cell registered table cells found")
        }
        
        cell.viewModel = viewModelForIndexPath(indexPath)
        
        return cell
    }
}