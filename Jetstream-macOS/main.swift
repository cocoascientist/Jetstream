//
//  main.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
