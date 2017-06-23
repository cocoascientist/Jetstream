//
//  AppDelegate.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let dataController = CoreDataController()
    
    private lazy var weatherModel: WeatherModel = {
        let weatherModel = WeatherModel(dataController: self.dataController)
        return weatherModel
    }()
    
    lazy var viewController: ViewController = {
        let viewController = ViewController()
        viewController.weatherModel = self.weatherModel
        
        return viewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        let interval = UIApplicationBackgroundFetchIntervalMinimum
        UIApplication.shared.setMinimumBackgroundFetchInterval(interval)
        
        UserDefaults.standard.register(defaults: applicationDefaults())
        UserDefaults.standard.synchronize()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        weatherModel.updateInBackground { (result) in
            switch result {
            case .newData:
                completionHandler(.newData)
            case .noData:
                completionHandler(.noData)
            }
        }
    }
}

