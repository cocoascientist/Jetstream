//
//  AppDelegate.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Cocoa
import SwiftUI
import JetstreamKit

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    
    lazy var weatherMenuItem: NSMenuItem = {
        let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        item.view = CustomMenuItemView(
            frame: NSRect(x: 0, y: 0, width: 200, height: 300)
        )
        
        return item
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )
        statusBarItem.button?.title = "🌯"

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu
        
        let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        item.view = CustomMenuItemView(
            frame: NSRect(x: 0, y: 0, width: 200, height: 300)
        )
        
        statusBarMenu.addItem(item)
        
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Quit", action: #selector(AppDelegate.handleQuitMenuItem), keyEquivalent: "")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func handleQuitMenuItem() {
        print("Ordering a burrito!")
    }


    @objc func cancelBurritoOrder() {
        print("Canceling your order :(")
    }
}

class CustomMenuItemView: NSView {
    private var hostingView: NSHostingView<SimpleView>

    override init(frame: NSRect) {
        hostingView = NSHostingView(rootView: SimpleView())

        super.init(frame: frame)
        addSubview(hostingView)
        hostingView.frame = bounds
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
//        effectView.isHidden = !(enclosingMenuItem?.isHighlighted ?? false)
    }
}

struct SimpleView: View {
    var body: some View {
        Text("Hello World")
            .font(.headline)
    }
}
