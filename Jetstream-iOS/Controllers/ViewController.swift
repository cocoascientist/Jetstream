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
    
    lazy var topConstraintToScrollView: NSLayoutConstraint = {
        guard let headerView = headerViewController.view else { fatalError() }
        let constraint = headerView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor)
        
        return constraint
    }()
    
    lazy var topConstraintToView: NSLayoutConstraint = {
        guard let headerView = headerViewController.view else { fatalError() }
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
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func applySceneViewConstraints() {
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func applyHeaderViewConstraints() {
        guard let headerView = headerViewController.view else { return }
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraintToScrollView
        ])
    }
    
    private func applyTemperatureViewConstraints() {
        guard let headerView = headerViewController.view else { return }
        guard let temperatureView = tempertureViewController.view else { return }
        
        NSLayoutConstraint.activate([
            temperatureView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            temperatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func applyHourlyForecastViewConstraints() {
        guard let hourlyForecastView = self.hourlyForecastViewController.view else { return }
        guard let temperatureView = tempertureViewController.view else { return }
        
        NSLayoutConstraint.activate([
            hourlyForecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourlyForecastView.topAnchor.constraint(equalTo: temperatureView.bottomAnchor),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: Size.DailyForecastView.height)
        ])
    }
    
    private func applyDetailsViewConstraints() {
        guard let hourlyForecastView = self.hourlyForecastViewController.view else { return }
        
        NSLayoutConstraint.activate([
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor),
            detailsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
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
            self.topConstraintToScrollView.isActive = false
            self.topConstraintToView.isActive = true
        } else {
            // if scrolling up, in a positive direction
            // break the top constraint on the superview and
            // attach top constraint on the scroll view
            
            // the prevents header view for scrolling out of view
            self.topConstraintToScrollView.isActive = true
            self.topConstraintToView.isActive = false
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
