//
//  AppDelegate.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 10/13/18.
//  Copyright © 2018 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet private weak var window: NSWindow!
    @IBOutlet private weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private let dataController = CoreDataController()
    
    private lazy var weatherModel: WeatherModel = {
        let weatherModel = WeatherModel(dataController: self.dataController)
        return weatherModel
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem.button?.title = "Test"
        statusItem.menu = statusMenu
        
        self.weatherModel.loadInitialModel { error in
            print("error: \(String(describing: error))")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func handleQuit(_ sender: Any) {
        
    }
}

