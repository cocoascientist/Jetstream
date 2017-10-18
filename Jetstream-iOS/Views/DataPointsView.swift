//
//  DataPointsView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/18/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class DataPointsView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    var viewModel: DataPointsViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            stackView.removeAllArrangedSubviews()
            addSubviewsToStackView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: ["stackView": stackView])
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: ["stackView": stackView])
        
        NSLayoutConstraint.activate(vertical)
        NSLayoutConstraint.activate(horizontal)
    }
    
    private func addSubviewsToStackView() {
        guard let dataPointGroups = viewModel?.dataPointGroups else { return }
        
        for group in dataPointGroups {
            let groupView = DataPointsGroupView()
            groupView.dataPointGroup = group
            
            stackView.addArrangedSubview(groupView)
            
            let width = NSLayoutConstraint(item: groupView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1, constant: 0)
            
            width.isActive = true
        }
    }
}

fileprivate class DataPointsGroupView: UIView {
    
    private func createDefaultLabel() -> UILabel {
        let label = createBlankLabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }
    
    private lazy var firstTitleLabel: UILabel = {
        return createDefaultLabel()
    }()
    
    private lazy var firstValueLabel: UILabel = {
        return createDefaultLabel()
    }()
    
    private lazy var secondTitleLabel: UILabel = {
        return createDefaultLabel()
    }()
    
    private lazy var secondValueLabel: UILabel = {
        return createDefaultLabel()
    }()
    
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
        super.init(frame: frame)
        
        layoutViewHierarchy()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func layoutViewHierarchy() {
        addSubview(firstTitleLabel)
        addSubview(firstValueLabel)
        addSubview(secondTitleLabel)
        addSubview(secondValueLabel)
    }
    
    private func applyConstraints() {
        applyFirstTitleLabelConstraints()
        applyFirstValueLabelConstraints()
        
        applySecondTitleLabelConstraints()
        applySecondValueLabelConstraints()
    }
    
    private func applyFirstTitleLabelConstraints() {
        let top = NSLayoutConstraint(item: firstTitleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 4)
        let centered = NSLayoutConstraint(item: firstTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -10)
        
        NSLayoutConstraint.activate([top, centered])
    }
    
    private func applyFirstValueLabelConstraints() {
        let centered = NSLayoutConstraint(item: firstValueLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 5)
        let baseline = NSLayoutConstraint(item: firstValueLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: firstTitleLabel, attribute: .firstBaseline, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([baseline, centered])
    }
    
    private func applySecondTitleLabelConstraints() {
        let top = NSLayoutConstraint(item: secondTitleLabel, attribute: .top, relatedBy: .equal, toItem: firstTitleLabel, attribute: .bottom, multiplier: 1, constant: 2)
        let centered = NSLayoutConstraint(item: secondTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -10)
        
        let bottom = NSLayoutConstraint(item: secondTitleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -4)
        
        NSLayoutConstraint.activate([top, centered, bottom])
    }
    
    private func applySecondValueLabelConstraints() {
        let centered = NSLayoutConstraint(item: secondValueLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 5)
        let baseline = NSLayoutConstraint(item: secondValueLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: secondTitleLabel, attribute: .firstBaseline, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([baseline, centered])
    }
}
