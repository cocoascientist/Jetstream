//
//  ForecastsDataSource.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ForecastsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var forecasts: [Forecast] = []
    private let conditionsModel: WeatherModel
    
    weak var tableView: UITableView? {
        didSet {
            let nib = UINib(nibName: "ForecastTableViewCell", bundle: nil)
            self.tableView?.registerNib(nib, forCellReuseIdentifier: "Cell")
            self.tableView?.reloadData()
        }
    }
    
    init(model: WeatherModel) {
        self.conditionsModel = model
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "forecastsDidUpdate:", name: ForecastDidUpdateNotification, object: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecasts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ForecastTableViewCell
        
        let viewModel = self.viewModelForIndexPath(indexPath)
        cell.viewModel = viewModel
        
        return cell
    }
    
    // MARK: - Private
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> ForecastViewModel {
        let forecast = self.forecasts[indexPath.row] as Forecast
        let viewModel = ForecastViewModel(forecast: forecast)
        return viewModel
    }
    
    func forecastsDidUpdate(notification: NSNotification) -> Void {
        let result = self.conditionsModel.currentForecast
        switch result {
        case .Success(let forecasts):
            println("forecasts updated!")
            self.forecasts = forecasts.unbox
            self.tableView?.reloadData()
        case .Failure(let reason):
            println("error updating forecasts, no data")
        }
    }
}
