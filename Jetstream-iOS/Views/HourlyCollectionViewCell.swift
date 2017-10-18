//
//  HourlyCollectionViewCell.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/1/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    
    private lazy var topLabel: UILabel = {
        let label = createBlankLabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Weather Icons", size: 22)
        label.textColor = .white
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = createBlankLabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    var viewModel: ForecastViewModel? {
        didSet {
            topLabel.text = viewModel?.hourOfDay
            iconLabel.text = viewModel?.weatherIcon
            bottomLabel.text = viewModel?.highTemp
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(topLabel)
        contentView.addSubview(iconLabel)
        contentView.addSubview(bottomLabel)
        
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        applyTopLabelConstraints()
        applyIconLabelConstraints()
        applyBottomLabelConstraints()
    }
    
    private func applyTopLabelConstraints() {
        let centerX = NSLayoutConstraint(item: topLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: topLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 4)
        
        NSLayoutConstraint.activate([centerX, top])
    }
    
    private func applyIconLabelConstraints() {
        let centerX = NSLayoutConstraint(item: iconLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerX, centerY])
    }
    
    private func applyBottomLabelConstraints() {
        let centerX = NSLayoutConstraint(item: bottomLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: bottomLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -4)
        
        NSLayoutConstraint.activate([centerX, bottom])
    }
}
