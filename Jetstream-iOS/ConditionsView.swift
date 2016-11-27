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

class ConditionsView: UIView {
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var weatherIconLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    
    var viewModel: ConditionsViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.cityNameLabel.text = viewModel.cityName
            self.weatherIconLabel.text = viewModel.weatherIcon
            self.summaryLabel.text = viewModel.summary
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let font = UIFont(name: "Weather Icons", size: 96.0)
        self.weatherIconLabel.font = font
        
        self.cityNameLabel.text = ""
        self.weatherIconLabel.text = ""
    }
}
