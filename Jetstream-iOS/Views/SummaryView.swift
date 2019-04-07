//
//  SummaryView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/18/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class SummaryView: UIView {
    
    var viewModel: ConditionsViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            label.text = viewModel.details
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel.blankLabel
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(label)
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
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
        
        layer.addSublayer(lineLayer)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8)
        ])
    }
}
