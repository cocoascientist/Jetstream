//
//  ForecastsDataSource.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation

public class ForecastsDataSource: NSObject {
    private(set) public var forecasts: [Forecast] = []
    public let conditionsModel: WeatherModel
    
//    weak var tableView: UITableView?
//        {
//        didSet {
//            let nib = UINib(nibName: ForecastTableViewCell.nibName, bundle: nil)
//            self.tableView?.register(nib, forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
//            
//            self.tableView?.dataSource = self
//            self.tableView?.reloadData()
//        }
//    }
    
    public init(model: WeatherModel) {
        self.conditionsModel = model
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ForecastsDataSource.forecastsDidUpdate(_:)), name: .forecastDidUpdate, object: nil)
    }
    
    public func forecastsDidUpdate(_ notification: Notification) -> Void {
        let result = self.conditionsModel.currentForecast
        switch result {
        case .success(let forecasts):
            self.forecasts = forecasts
//            self.tableView?.reloadData()
        case .failure:
            print("error updating forecasts, no data")
        }
    }
    
    // MARK: - Private
    
    fileprivate func viewModelForIndexPath(_ indexPath: IndexPath) -> ForecastViewModel {
        let forecast = self.forecasts[indexPath.row]
        let viewModel = ForecastViewModel(forecast: forecast)
        return viewModel
    }
}

//extension ForecastsDataSource: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.forecasts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseIdentifier, for: indexPath) as? ForecastTableViewCell else {
//            fatalError("cell registered table cells found")
//        }
//        
//        cell.viewModel = self.viewModelForIndexPath(indexPath)
//        
//        return cell
//    }
//}
