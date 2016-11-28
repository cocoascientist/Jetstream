//
//  WindowController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/10/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import CoreLocation
import JetstreamKit

class WindowController: NSWindowController {
    
    @IBOutlet var searchTextField: NSTextField!
    @IBOutlet var locationButton: NSButton!
    
    private let dataController = CoreDataController()
    
    fileprivate lazy var weatherModel: WeatherModel = {
        let weatherModel = WeatherModel(dataController: self.dataController)
        return weatherModel
    }()
    
    fileprivate let geocoder = CLGeocoder()
    
    class var windowIdentifier: String {
        return "MainWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        self.window?.titleVisibility = .hidden

        self.windowFrameAutosaveName = WindowController.windowIdentifier
        
        self.contentViewController?.representedObject = self.weatherModel
        
        self.locationButton.font = NSFont(name: "FontAwesome", size: 12.0)
        self.locationButton.title = "\u{f124}"
    }
}

extension WindowController: NSTextFieldDelegate {
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.userInfo?["NSFieldEditor"] as? NSTextView else { return }
        guard let string = textField.textStorage?.string else { return }
        
        geocoder.geocodeAddressString(string) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first {
                guard let physical = placemark.location else { return }
                
                guard let city = placemark.locality else { return }
                guard let state = placemark.administrativeArea else { return }
                
                let location = Location(location: physical, city: city, state: state)
                
                self?.weatherModel.updateWeather(for: location)
            }
        }
    }
}
