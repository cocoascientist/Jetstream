//
//  StatusBarMenuController.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/20/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamCore

class StatusBarMenuController: NSObject {
    
    private let weatherService: WeatherService
    
    private lazy var weatherMenuItem: NSMenuItem = {
        let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        item.view = CustomMenuItemView(
            frame: NSRect(x: 0, y: 0, width: 200, height: 150),
            view: ContentView()
                .environment(
                    \.managedObjectContext,
                    weatherService.dataStore.managedObjectContext
                )
        )
        
        return item
    }()
    
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func createStatusMenu() {
        statusBarItem.button?.title = "\u{f050}"
        statusBarItem.button?.font = NSFont(name: "Weather Icons", size: 14.0)

        let statusBarMenu = NSMenu()
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(weatherMenuItem)
        statusBarMenu.addItem(NSMenuItem.separator())
        
        statusBarMenu.addItem(
            withTitle: "Preferences...",
            action: #selector(StatusBarMenuController.handleQuitMenuItem(_:)),
            keyEquivalent: ""
        )
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(StatusBarMenuController.handlePreferencesMenuItem(_:)),
            keyEquivalent: ""
        )
    }
    
    @objc func handleQuitMenuItem(_ sender: Any) {
        // TODO
    }
    
    @objc func handlePreferencesMenuItem(_ sender: Any) {
        // TODO
    }
}
