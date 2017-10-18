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
        let label = createBlankLabel()
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
    
    private func applyConstraints() {
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[label]-8-|", options: [], metrics: nil, views: ["label": label])
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[label]-16-|", options: [], metrics: nil, views: ["label": label])
        
        NSLayoutConstraint.activate(vertical)
        NSLayoutConstraint.activate(horizontal)
    }
}
