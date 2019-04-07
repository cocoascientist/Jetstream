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
    
    private let cellIdentifier = "HourlyCollectionViewCell"
    
    private var dailyForecasts: [Forecast] = []
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 115)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 1.0
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = HourlyForecastBackgroundView(frame: .zero)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
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
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let rect = layer.bounds
        
        let top = UIBezierPath()
        top.move(to: CGPoint(x: rect.minX, y: rect.minY + 1.5))
        top.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 1.5))
        
        let bottom = UIBezierPath()
        bottom.move(to: CGPoint(x: rect.minX, y: rect.maxY - 1.5))
        bottom.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 1.5))
        
        addDecorationLayer(path: top)
        addDecorationLayer(path: bottom)
    }
    
    private func addDecorationLayer(path: UIBezierPath) {
        let lineLayer = CAShapeLayer()
        
        lineLayer.path = path.cgPath
        lineLayer.fillColor = UIColor.white.cgColor
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.opacity = 1.0
        lineLayer.lineWidth = 1.0
        
        layer.addSublayer(lineLayer)
    }
}
