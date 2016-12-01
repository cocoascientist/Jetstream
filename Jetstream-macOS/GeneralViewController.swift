//
//  GeneralViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/29/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa

class GeneralViewController: NSViewController {
    
    @IBOutlet var unitsMatrix: NSMatrix!
    @IBOutlet var updateIntervalMatrix: NSMatrix!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = NSUserDefaultsController.shared()
        unitsMatrix.bind(NSSelectedIndexBinding, to: controller, withKeyPath: "values.units", options: nil)
        updateIntervalMatrix.bind(NSSelectedIndexBinding, to: controller, withKeyPath: "values.interval", options: nil)
    }
}
