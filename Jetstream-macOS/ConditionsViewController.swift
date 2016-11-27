//
//  ConditionsViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/8/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ConditionsViewController: NSViewController {
    
    @IBOutlet weak var cityNameLabel: NSTextField!
    @IBOutlet weak var weatherIconLabel: NSTextField!
    @IBOutlet weak var summaryLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherIconLabel.font = NSFont(name: "Weather Icons", size: 132.0)
        self.cityNameLabel.font = NSFont.systemFont(ofSize: 18.0)
        self.summaryLabel.font = NSFont.systemFont(ofSize: 18.0)
    }
    
    override var representedObject: Any? {
        didSet {
            guard let viewModel = representedObject as? ConditionsViewModel else { return }
            
            self.cityNameLabel.stringValue = viewModel.cityName
            self.weatherIconLabel.stringValue = viewModel.weatherIcon
            self.summaryLabel.stringValue = viewModel.summary
        }
    }
}
