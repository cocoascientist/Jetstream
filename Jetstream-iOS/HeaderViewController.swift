//
//  HeaderViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class HeaderViewController: UIViewController {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    var viewModel: ConditionsViewModel? {
        didSet {
            self.cityLabel.text = viewModel?.cityName ?? ""
            self.summaryLabel.text = viewModel?.summary ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cityLabel.text = "City Name"
        summaryLabel.text = "Summary"
    }
    
    func adjustAppearence(using contentOffset: CGPoint) {
        topConstraint.constant = calculateTopConstraint(using: contentOffset)
    }
}

fileprivate func calculateTopConstraint(using contentOffset: CGPoint) -> CGFloat {
    if contentOffset.y <= 0.0 {
        return Size.headerViewMaxTopConstraint
    } else if contentOffset.y > 0.0 && contentOffset.y < Size.headerViewTopConstraintThreshold {
        return Size.headerViewMaxTopConstraint - contentOffset.y
    } else {
        return Size.headerViewMinTopConstraint
    }
}
