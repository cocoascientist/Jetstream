//
//  ForecastTableViewCell.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet var forecastLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    
    var viewModel: ForecastViewModel! {
        didSet {
            self.forecastLabel.text = viewModel.forecastString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.forecastLabel.text = ""
        self.secondaryLabel.text = ""
        
        let font = UIFont(name: "Weather Icons", size: 20.0)
        self.forecastLabel.font = font

        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        self.forecastLabel.textColor = UIColor.whiteColor()
        self.secondaryLabel.textColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
