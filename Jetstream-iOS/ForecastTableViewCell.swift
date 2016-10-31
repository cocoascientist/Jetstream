//
//  ForecastTableViewCell.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/22/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var forecastLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    
    static let reuseIdentifier = "\(ForecastTableViewCell.self)"
    
    var viewModel: ForecastViewModel! {
        didSet {
            self.iconLabel.text = viewModel.weatherIcon
            self.forecastLabel.text = viewModel.dayString
            self.secondaryLabel.text = viewModel.temperatureRange
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconLabel.text = ""
        self.forecastLabel.text = ""
        self.secondaryLabel.text = ""
        
        let font = UIFont(name: "Weather Icons", size: 20.0)
        self.iconLabel.font = font

        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.iconLabel.textColor = UIColor.white
        self.forecastLabel.textColor = UIColor.white
        self.secondaryLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
