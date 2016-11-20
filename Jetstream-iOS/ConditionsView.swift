//
//  ConditionsHeaderView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import Foundation
import UIKit
import JetstreamKit
import PocketSVG

class ConditionsView: UIView {
//    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var weatherIconView: SVGImageView!
    
//    @IBOutlet var conditionsLabel: UILabel!
//    @IBOutlet var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.cityNameLabel.text = ""
//        self.conditionsLabel.text = ""
//        self.temperatureLabel.text = ""
//        self.temperatureRangeLabel.text = ""
        
//        let font = UIFont(name: "Weather Icons", size: 40.0)
//        self.weatherIconLabel.font = font
//        self.weatherIconLabel.text = "\u{f00d}"
        
//        if let weatherView = weatherView(forImageName: "sun") {
//            self.stackView.addArrangedSubview(weatherView)
//        }
        
        guard let url = Bundle.main.url(forResource: "sun", withExtension: "svg") else { return }
        let string = try! String(contentsOf: url)
        
        self.weatherIconView.svgSource = string
    }
    
    
}

//private func weatherView(forImageName resource: String) -> UIView? {
//    guard let svgView = svgImageView(forResource: resource) else {
//        return nil
//    }
//    
//    let container = UIView()
//    
//    container.addSubview(svgView)
//    
//    let centerX = NSLayoutConstraint(item: svgView, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0)
//    let centerY = NSLayoutConstraint(item: svgView, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0)
//    
//    container.addConstraint(centerX)
//    container.addConstraint(centerY)
//    
//    return container
//}

private func svgImageView(forResource name: String) -> SVGImageView? {
    guard let url = Bundle.main.url(forResource: name, withExtension: "svg") else { return nil }
    

    
    let svgView = SVGImageView(contentsOf: url)
//    svgView.translatesAutoresizingMaskIntoConstraints = false
//    
//    let widthConstraint = NSLayoutConstraint(item: svgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
//    let heightConstraint = NSLayoutConstraint(item: svgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
//    
//    svgView.addConstraint(widthConstraint)
//    svgView.addConstraint(heightConstraint)
    
    return svgView
}
