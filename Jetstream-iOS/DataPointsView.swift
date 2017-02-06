//
//  DataPointsView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/3/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class DataPointsView: UIView {
    
    let firstTitleLabel: UILabel
    let firstValueLabel: UILabel
    
    let secondTitleLabel: UILabel
    let secondValueLabel: UILabel
    
    var dataPointGroup: DataPointGroup? {
        didSet {
            guard let pair = dataPointGroup else { return }
            
            firstTitleLabel.text = "\(pair.first.name):"
            firstValueLabel.text = pair.first.value
            
            secondTitleLabel.text = "\(pair.second.name):"
            secondValueLabel.text = pair.second.value
        }
    }

    override init(frame: CGRect) {
        self.firstTitleLabel = UILabel(frame: .zero)
        self.firstValueLabel = UILabel(frame: .zero)
        self.secondTitleLabel = UILabel(frame: .zero)
        self.secondValueLabel = UILabel(frame: .zero)
        
        super.init(frame: frame)
        
        let defaultFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        firstTitleLabel.font = defaultFont
        firstValueLabel.font = defaultFont
        secondTitleLabel.font = defaultFont
        secondValueLabel.font = defaultFont
        
        self.addSubview(firstTitleLabel)
        self.addSubview(firstValueLabel)
        self.addSubview(secondTitleLabel)
        self.addSubview(secondValueLabel)
        
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func applyConstraints() {
        applyFirstTitleLabelConstraints()
        applyFirstValueLabelConstraints()
        
        applySecondTitleLabelConstraints()
        applySecondValueLabelConstraints()
    }
    
    func applyFirstTitleLabelConstraints() {
        firstTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: firstTitleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 4)
        let centered = NSLayoutConstraint(item: firstTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -10)
        
        self.addConstraints([top, centered])
    }
    
    func applyFirstValueLabelConstraints() {
        firstValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centered = NSLayoutConstraint(item: firstValueLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 5)
        let baseline = NSLayoutConstraint(item: firstValueLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: firstTitleLabel, attribute: .firstBaseline, multiplier: 1, constant: 0)
        
        self.addConstraints([baseline, centered])
    }
    
    func applySecondTitleLabelConstraints() {
        secondTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: secondTitleLabel, attribute: .top, relatedBy: .equal, toItem: firstTitleLabel, attribute: .bottom, multiplier: 1, constant: 2)
        let centered = NSLayoutConstraint(item: secondTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -10)
        
        let bottom = NSLayoutConstraint(item: secondTitleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -4)
        
        self.addConstraints([top, centered, bottom])
    }
    
    func applySecondValueLabelConstraints() {
        secondValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centered = NSLayoutConstraint(item: secondValueLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 5)
        let baseline = NSLayoutConstraint(item: secondValueLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: secondTitleLabel, attribute: .firstBaseline, multiplier: 1, constant: 0)
        
        self.addConstraints([baseline, centered])
    }
}
