//
//  AppDelegate.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/3/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    fileprivate lazy var conditionsMenuItem: NSMenuItem = {
        return NSMenuItem(title: "Current Conditions: Loading...", action: nil, keyEquivalent: "")
    }()
    
    fileprivate lazy var statusMenu: NSMenu = {
        let menu = NSMenu(title: "Jetstream")
        
        return menu
    }()
    
    lazy var preferencesController: NSWindowController = {
        let storyboard = NSStoryboard(name: "Preferences", bundle: nil)
        guard let controller = storyboard.instantiateInitialController() as? NSWindowController else {
            fatalError("initial view controller not found")
        }
        
        return controller
    }()
    
    fileprivate let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        self.statusMenu.addItem(conditionsMenuItem)
        
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showPreferences(sender: Any) {
        preferencesController.showWindow(nil)
    }
}

