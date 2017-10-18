//
//  HourlyForecastViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/1/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class HourlyForecastViewController: UIViewController {
    
//    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate let cellIdentifier = "HourlyCollectionViewCell"
    
    private var dailyForecasts: [Forecast] = []
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 85)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 1.0
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = HourlyForecastBackgroundView(frame: .zero)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        
        return collectionView
    }()
    
    var viewModel: ForecastsViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView])
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView])
        
        NSLayoutConstraint.activate(vertical)
        NSLayoutConstraint.activate(horizontal)
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + 1.5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 1.5))
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 1.5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 1.5))
        
        UIColor.white.setStroke()
        
        path.lineWidth = 1.0
        path.stroke()
    }
}
