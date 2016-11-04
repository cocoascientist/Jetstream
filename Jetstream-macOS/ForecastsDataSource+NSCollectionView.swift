//
//  ForecastsDataSource+NSCollectionView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/4/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import AppKit
import JetstreamKit

extension ForecastsDataSource: NSCollectionViewDataSource {
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecasts.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: "ForecastCollectionViewItem", for: indexPath) as? ForecastCollectionViewItem else { fatalError() }
        
        let forecast = forecasts[indexPath.item]
        item.representedObject = ForecastViewModel(forecast: forecast)
        
        return item
    }
}
