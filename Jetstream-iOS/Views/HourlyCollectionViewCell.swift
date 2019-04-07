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
        let label = UILabel.blankLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Weather Icons", size: 26)
        label.textColor = .white
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel.blankLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    var viewModel: ForecastViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            iconLabel.text = viewModel.weatherIcon
            bottomLabel.text = viewModel.highTemp
            
            topLabel.attributedText = formattedHourOfDayString(from: viewModel.hourOfDay)
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
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            iconLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func formattedHourOfDayString(from text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let pmRange = text.range(of: "PM")
        let amRange = text.range(of: "AM")
        
        let font = createSmallCapsFont(withTextStyle: .caption1)
        
        if pmRange != nil {
            attributedString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(pmRange!, in: text))
        }
        
        if amRange != nil {
            attributedString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(amRange!, in: text))
        }
        
        return attributedString
    }
}
