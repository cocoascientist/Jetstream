//
//  TemperatureRangeView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/23/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import UIKit

class TemperatureRangeView: UIView {

    @IBOutlet var highTemperatureLabel: UILabel!
    @IBOutlet var lowTemperatureLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        path.stroke()
    }

}
