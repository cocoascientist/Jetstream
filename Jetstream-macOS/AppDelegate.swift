//
//  AppDelegate.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 10/11/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem.title = NSLocalizedString("Weather", comment: "Weather")
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func handleQuit(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
}
