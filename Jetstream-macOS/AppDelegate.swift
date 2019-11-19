//
//  AppDelegate.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Cocoa
import SwiftUI
import JetstreamCore

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    
    private lazy var weatherService: WeatherService = {
        // Create a dummy URL Session
//        let configuration = URLSessionConfiguration.configurationWithProtocol(LocalURLProtocol.self)
//        let session = URLSession.init(configuration: configuration)
        
        let dataController = CoreDataController()
        let weatherService = WeatherService(dataController: dataController)
        
        return weatherService
    }()
    
    private lazy var statusBarMenuController: StatusBarMenuController = {
        return StatusBarMenuController(weatherService: self.weatherService)
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusBarMenuController.createStatusMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
