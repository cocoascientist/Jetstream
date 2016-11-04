//
//  ForecastCollectionViewItem.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/4/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ForecastCollectionViewItem: NSCollectionViewItem {
    
    var forecast: Forecast?
    
    @IBOutlet weak var dayLabel: NSTextField!
    @IBOutlet weak var conditionsLabel: NSTextField!
    
    @IBOutlet weak var highTempLabel: NSTextField!
    @IBOutlet weak var lowTempLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.conditionsLabel.font = NSFont(name: "pe-icon-set-weather", size: 32.0)
        
        self.conditionsLabel.textColor = NSColor.white
        self.dayLabel.textColor = NSColor.white
        self.highTempLabel.textColor = NSColor.white
        self.lowTempLabel.textColor = NSColor.lightGray
        
        self.conditionsLabel.backgroundColor = NSColor.orange
    }
    
    override var representedObject: Any? {
        didSet {
            guard let viewModel = representedObject as? ForecastViewModel else { return }
            
            self.dayLabel.stringValue = viewModel.dayString
            self.conditionsLabel.stringValue = "\u{e915}"
            
            self.highTempLabel.stringValue = viewModel.highTemperature
            self.lowTempLabel.stringValue = viewModel.lowTemperature
        }
    }
}
