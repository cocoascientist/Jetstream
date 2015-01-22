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
    private let conditionsModel: ConditionsModel
    
    weak var tableView: UITableView? {
        didSet {
            self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            self.tableView?.reloadData()
        }
    }
    
    init(model: ConditionsModel) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let forecast = self.forecasts[indexPath.row] as Forecast
        cell.textLabel?.text = forecast.conditions.description
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    // MARK: - Private
    
    func forecastsDidUpdate(notification: NSNotification) -> Void {
        let result = self.conditionsModel.currentForecasts()
        switch result {
        case .Success(let forecasts):
            println("forecasts updated!")
            self.forecasts = forecasts()
            self.tableView?.reloadData()
        case .Failure(let reason):
            println("error updating forecasts, no data")
        }
    }
}
