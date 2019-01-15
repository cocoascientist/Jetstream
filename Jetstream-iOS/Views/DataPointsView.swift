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
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -10)
        ])
    }
    
    private func addSubviewsToStackView() {
        guard let dataPointGroups = viewModel?.dataPointGroups else { return }
        
        dataPointGroups.forEach { (group) in
            let groupView = DataPointsGroupView()
            groupView.dataPointGroup = group
            stackView.addArrangedSubview(groupView)
            groupView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
}

private class DataPointsGroupView: UIView {
    
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
        NSLayoutConstraint.activate([
            firstTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            firstTitleLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            
            firstValueLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5),
            firstValueLabel.firstBaselineAnchor.constraint(equalTo: firstTitleLabel.firstBaselineAnchor),
            
            secondTitleLabel.topAnchor.constraint(equalTo: firstTitleLabel.bottomAnchor, constant: 2),
            secondTitleLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            secondTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            secondValueLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5),
            secondValueLabel.firstBaselineAnchor.constraint(equalTo: secondTitleLabel.firstBaselineAnchor)
        ])
    }
    
    private func createDefaultLabel() -> UILabel {
        let label = UILabel.blankLabel
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }
}
