//
//  ForecastViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/8/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ForecastViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateForecast(with forecasts: [Forecast]) {
        
    }
}
