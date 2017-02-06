//
//  HourlyForecastViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/1/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class HourlyForecastViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate let cellIdentifier = "HourlyCollectionViewCell"
    
    private var dailyForecasts: [Forecast] = []
    
    var viewModel: ForecastsViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib.init(nibName: "HourlyCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 85)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 1.0
        
        collectionView.collectionViewLayout = layout
    }
}

extension HourlyForecastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.hourlyForecasts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HourlyCollectionViewCell else { fatalError() }
        
        guard let viewModel = viewModel?.hourlyForecasts[indexPath.row] else { return cell }
        
        cell.viewModel = viewModel
        
        return cell
    }
}

class HourlyForecastBackgroundView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + 1.5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 1.5))
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 1.5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 1.5))
        
        UIColor.black.setStroke()
        
        path.lineWidth = 1.0
        path.stroke()
    }
}
