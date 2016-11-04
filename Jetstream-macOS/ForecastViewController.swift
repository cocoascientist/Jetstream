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
    
    var forecastsDataSource: ForecastsDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.forecastsDataSource = ForecastsDataSource()
        
        let nib = NSNib(nibNamed: "ForecastCollectionViewItem", bundle: nil)
        collectionView.register(nib, forItemWithIdentifier: "ForecastCollectionViewItem")
        
        self.view.wantsLayer = true
        self.collectionView.layer?.backgroundColor = NSColor.hexColor("#2b323a").cgColor
        self.collectionView.dataSource = forecastsDataSource
    }
    
    func updateForecast(with forecasts: [Forecast]) {
        
//        self.forecastsDataSource = ForecastsDataSource(forecasts: forecasts)
//        self.collectionView.dataSource = forecastsDataSource
//        
//        self.collectionView.reloadData()
    }
}
