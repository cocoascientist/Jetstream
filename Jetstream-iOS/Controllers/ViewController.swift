//
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import SceneKit
import JetstreamKit

final class ViewController: UIViewController {
    
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
    
    lazy var detailsView: DetailsView = {
        let view = DetailsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        
        return scrollView
    }()
    
    lazy var sceneView: WeatherSceneView = {
        let view = WeatherSceneView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var topConstaintToScrollView: NSLayoutConstraint = {
        guard let headerView = self.headerViewController.view else { fatalError() }
        let scrollView = self.scrollView
        
        let constraint = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0)
        
        return constraint
    }()
    
    lazy var topConstaintToView: NSLayoutConstraint = {
        guard let headerView = self.headerViewController.view else { fatalError() }
        let constraint = headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        
        return constraint
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        
        let title = "Pull to Refresh"
        let string = NSMutableAttributedString(string: title)
        string.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0, string.length))
        
        control.attributedTitle = string

        control.addTarget(self, action: #selector(ViewController.shouldTriggerRefresh), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        view.backgroundColor = blueColor
        
        layoutViewHeirarchy()
        applyConstraints()
        listenForNotifications()
        
        self.weatherModel.loadInitialModel { [weak self] error in
            self?.loadCachedWeather()
            self?.update()
        }
    }
    
    private func layoutViewHeirarchy() {
//        view.addSubview(sceneView)
        view.addSubview(scrollView)
        
        addChild(headerViewController)
        addChild(tempertureViewController)
        addChild(hourlyForecastViewController)
        
        scrollView.addSubview(detailsView)
        
        scrollView.addSubview(headerViewController.view)
        scrollView.addSubview(tempertureViewController.view)
        scrollView.addSubview(hourlyForecastViewController.view)
        
        scrollView.refreshControl = refreshControl
    }
    
    private func applyConstraints() {
//        applySceneViewConstraints()
        applyScrollViewConstraints()
        
        applyHeaderViewConstraints()
        applyTemperatureViewConstraints()
        applyHourlyForecastViewConstraints()
        
        applyDetailsViewConstraints()
    }
    
    private func applyScrollViewConstraints() {
        let margins = view.layoutMarginsGuide
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func applySceneViewConstraints() {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[sceneView]|", options: [], metrics: nil, views: ["sceneView": sceneView])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[sceneView]|", options: [], metrics: nil, views: ["sceneView": sceneView])
        
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
    }
    
    private func applyHeaderViewConstraints() {
        guard let headerView = headerViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = topConstaintToScrollView
        
        let constraints = [top, leading, trailing]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func applyTemperatureViewConstraints() {
        guard let headerView = headerViewController.view else { return }
        guard let temperatureView = tempertureViewController.view else { return }
        
        let top = NSLayoutConstraint(item: temperatureView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: temperatureView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: temperatureView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, leading, trailing])
    }
    
    private func applyHourlyForecastViewConstraints() {
        guard let hourlyForecastView = self.hourlyForecastViewController.view else { return }
        guard let temperatureView = tempertureViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: hourlyForecastView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: hourlyForecastView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: hourlyForecastView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Size.dailyForecastViewHeight)
        
        let top = NSLayoutConstraint(item: hourlyForecastView, attribute: .top, relatedBy: .equal, toItem: temperatureView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leading, trailing, height, top])
    }
    
    private func applyDetailsViewConstraints() {
        guard let hourlyForecastView = self.hourlyForecastViewController.view else { return }
        
        let leading = NSLayoutConstraint(item: detailsView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: detailsView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: detailsView, attribute: .top, relatedBy: .equal, toItem: hourlyForecastView, attribute: .bottom, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: detailsView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}

extension ViewController {
    @objc internal func didReceiveError(notification: Notification) -> Void {
        print("error: \(notification)")
    }
    
    @objc internal func didReceiveUpdate(notification: Notification) -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.loadCachedWeather()
        }
    }
    
    @objc internal func didEnterBackground(notification: Notification) {
        //
    }
    
    @objc internal func willEnterForeground(notification: Notification) {
        self.loadCachedWeather()
        self.update()
    }
    
    @objc internal func shouldTriggerRefresh() -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.update()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc internal func update() {
        self.weatherModel.updateWeatherForCurrentLocation()
    }
    
    internal func loadCachedWeather() {
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
        detailsView.conditionsViewModel = viewModel
    }
    
    internal func updateForecasts(with viewModel: ForecastsViewModel) {
        hourlyForecastViewController.viewModel = viewModel
        detailsView.forecastsViewModel = viewModel
    }
    
    internal func refreshIfNecessary() {
        weatherModel.updateWeatherForCurrentLocation()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset =  scrollView.contentOffset

        adjustAppearence(using: offset)
        headerViewController.adjustAppearence(using: offset)
        tempertureViewController.adjustAppearence(using: offset)
        detailsView.adjustAppearence(using: offset)
    }
}

extension ViewController {
    private func adjustAppearence(using offset: CGPoint) {
        if offset.y >= 0 {
            // if scrolling down, in a negative direction (pull-to-refresh)
            // break the top constraint on the scroll view and
            // attach the top constraint on the superview
            
            // this allows header view to scroll down to reveal refresh control
            self.topConstaintToScrollView.isActive = false
            self.topConstaintToView.isActive = true
        } else {
            // if scrolling up, in a positive direction
            // break the top constraint on the superview and
            // attach top constraint on the scroll view
            
            // the prevents header view for scrolling out of view
            self.topConstaintToScrollView.isActive = true
            self.topConstaintToView.isActive = false
        }
    }
    
    private func listenForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveUpdate), name: .conditionsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveError), name: .weatherModelDidReceiveError, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didEnterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.willEnterForeground(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // FIXME: Only call update if "units" preferences changed.
        // If "cache" or "interval" changes, do something else.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.update), name: UserDefaults.didChangeNotification, object: nil)
    }
}
