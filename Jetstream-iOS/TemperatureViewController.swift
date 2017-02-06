//
//  TemperatureViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class TemperatureViewController: UIViewController {
    
    @IBOutlet var currentTemperatureLabel: UILabel!
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dayDetailLabel: UILabel!
    
    @IBOutlet var highTemperatureLabel: UILabel!
    @IBOutlet var lowTemperatureLabel: UILabel!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    var viewModel: ConditionsViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            currentTemperatureLabel.text = viewModel.currentTemperature
            highTemperatureLabel.text = viewModel.highTemperature
            lowTemperatureLabel.text = viewModel.lowTemperature
            
            dayLabel.text = viewModel.day
            dayDetailLabel.text = "Today"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dayLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        dayDetailLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        
        highTemperatureLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        lowTemperatureLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
    }
    
    func adjustAppearence(using contentOffset: CGPoint) {
        currentTemperatureLabel.alpha = alphaPercent(using: contentOffset)
        dayLabel.alpha = alphaPercent(using: contentOffset)
        dayDetailLabel.alpha = alphaPercent(using: contentOffset)
        highTemperatureLabel.alpha = alphaPercent(using: contentOffset)
        lowTemperatureLabel.alpha = alphaPercent(using: contentOffset)
        
        topConstraint.constant = calculateBottomConstraint(using: contentOffset)
    }
}

fileprivate func alphaPercent(using contentOffset: CGPoint) -> CGFloat {
    if contentOffset.y <= 0.0 {
        return 1.0
    } else if contentOffset.y > 0.0 && contentOffset.y < 100.0 {
        return 1.0 - (contentOffset.y / 100.0)
    } else {
        return 0.0
    }
}

fileprivate func calculateBottomConstraint(using contentOffset: CGPoint) -> CGFloat {
    if contentOffset.y <= 35.0 {
        return 121.0
    } else if contentOffset.y > 35.0 && contentOffset.y < 170.0 {
        let difference = contentOffset.y - Size.headerViewTopConstraintThreshold
        return 121.0 - difference
    } else {
        return -14
    }
}
