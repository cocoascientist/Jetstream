//
//  SummaryViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/3/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class SummaryViewController: UIViewController {
    
    @IBOutlet var summaryLabel: UILabel!
    
    var viewModel: ConditionsViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            summaryLabel.text = viewModel.details
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        summaryLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
    }
}

class SummaryBackgroundView: UIView {
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
