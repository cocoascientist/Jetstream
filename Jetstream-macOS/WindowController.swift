//
//  WindowController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/10/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import CoreLocation

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        self.window?.titleVisibility = .hidden
    }

    @IBAction func handleLocationButton(sender: Any) {
        print("something!")
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString("Bellingham, WA") { (placemark, error) in
            print("done")
        }
    }
}
