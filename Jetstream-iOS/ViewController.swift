
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class ViewController: UIViewController {
    
    var weatherModel: WeatherModel! = nil
    
    lazy var hourlyForecastViewController: HourlyForecastViewController = {
        let viewController = HourlyForecastViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    lazy var headerViewController: HeaderViewController = {
        let viewController = HeaderViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    lazy var tempertureViewController: TemperatureViewController = {
        let viewController = TemperatureViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    lazy var weeklyForecastViewController: WeeklyForecastViewController = {
        let viewController = WeeklyForecastViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    lazy var summaryViewController: SummaryViewController = {
        let viewController = SummaryViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    lazy var dataPointsViewController: DataPointsViewController = {
        let viewController = DataPointsViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor.white
        
        layoutViewHeirarchy()
        applyConstraints()
        listenForNotifications()
        
        self.weatherModel.loadInitialModel { [weak self] error in
            self?.reload()
            self?.update()
        }
    }
    
    private func layoutViewHeirarchy() {
        view.addSubview(scrollView)
        
        addChildViewController(headerViewController)
        addChildViewController(tempertureViewController)
        addChildViewController(hourlyForecastViewController)
        addChildViewController(weeklyForecastViewController)
        addChildViewController(summaryViewController)
        addChildViewController(dataPointsViewController)
        
        scrollView.addSubview(weeklyForecastViewController.view)
        scrollView.addSubview(summaryViewController.view)
        scrollView.addSubview(dataPointsViewController.view)
        
        scrollView.addSubview(headerViewController.view)
        scrollView.addSubview(tempertureViewController.view)
        scrollView.addSubview(hourlyForecastViewController.view)
    }
    
    private func applyConstraints() {
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": self.scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": self.scrollView]))
        
        applyHeaderViewConstraints()
        applyTemperatureViewConstraints()
        applyHourlyForecastViewConstraints()
        applyWeeklyForecastViewConstraints()
        applySummaryViewConstraints()
        applyDataPointsViewConstraints()
    }
    
    private func applyHeaderViewConstraints() {
        guard let headerView = headerViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        
        let constraints = [top, leading, trailing]
        view.addConstraints(constraints)
    }
    
    private func applyTemperatureViewConstraints() {
        guard let headerView = headerViewController.view else { return }
        guard let temperatureView = tempertureViewController.view else { return }
        
        let top = NSLayoutConstraint(item: temperatureView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: temperatureView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: temperatureView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        let constraints = [top, leading, trailing]
        view.addConstraints(constraints)
    }
    
    private func applyHourlyForecastViewConstraints() {
        guard let hourlyForecastView = self.hourlyForecastViewController.view else { return }
        guard let temperatureView = tempertureViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: hourlyForecastView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: hourlyForecastView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: hourlyForecastView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Size.dailyForecastViewHeight)
        
        let top = NSLayoutConstraint(item: hourlyForecastView, attribute: .top, relatedBy: .equal, toItem: temperatureView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let constraints = [leading, trailing, height, top]
        view.addConstraints(constraints)
    }
    
    private func applyWeeklyForecastViewConstraints() {
        guard let weeklyForecastView = self.weeklyForecastViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: weeklyForecastView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: weeklyForecastView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: weeklyForecastView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 350)
        
        let constraints = [leading, trailing, top]
        view.addConstraints(constraints)
    }
    
    private func applySummaryViewConstraints() {
        guard let summaryView = self.summaryViewController.view else { return }
        guard let weeklyForecastView = self.weeklyForecastViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: summaryView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: summaryView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: summaryView, attribute: .top, relatedBy: .equal, toItem: weeklyForecastView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let constraints = [leading, trailing, top]
        view.addConstraints(constraints)
    }
    
    private func applyDataPointsViewConstraints() {
        guard let dataPointsView = self.dataPointsViewController.view else { return }
        guard let summaryView = self.summaryViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: dataPointsView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: dataPointsView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: dataPointsView, attribute: .top, relatedBy: .equal, toItem: summaryView, attribute: .bottom, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: dataPointsView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: -4)
        
        let constraints = [leading, trailing, top, bottom]
        view.addConstraints(constraints)
    }
}

extension ViewController {
    internal func didReceiveError(notification: Notification) -> Void {
        print("error: \(notification)")
    }
    
    internal func didReceiveUpdate(notification: Notification) -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.reload()
        }
    }
    
    internal func shouldTriggerRefresh() -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.update()
//            self?.refreshControl.endRefreshing()
        }
    }
    
    internal func update() {
        self.weatherModel.updateWeatherForCurrentLocation()
    }
    
    internal func reload() {
        let result = self.weatherModel.currentWeather()
        
        switch result {
        case .success(let weather):
            let conditionsViewModel = ConditionsViewModel(weather: weather)
            updateConditions(with: conditionsViewModel)
            
            let forecastsViewModel = ForecastsViewModel(weather: weather)
            updateForecasts(with: forecastsViewModel)
        case .failure(let error):
            print("error updating view model: \(error)")
        }
    }
    
    internal func updateConditions(with viewModel: ConditionsViewModel) {
        headerViewController.viewModel = viewModel
        tempertureViewController.viewModel = viewModel
        summaryViewController.viewModel = viewModel
        
        dataPointsViewController.viewModel = viewModel.dataPointsViewModel
    }
    
    internal func updateForecasts(with viewModel: ForecastsViewModel) {
        weeklyForecastViewController.viewModel = viewModel
        hourlyForecastViewController.viewModel = viewModel
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset =  scrollView.contentOffset
        
        headerViewController.adjustAppearence(using: offset)
        tempertureViewController.adjustAppearence(using: offset)
    }
}

extension ViewController {
    
    fileprivate func listenForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.update), name: UserDefaults.didChangeNotification, object: nil)
    }
}
