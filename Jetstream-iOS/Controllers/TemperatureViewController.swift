//
//  TemperatureViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class TemperatureViewController: UIViewController {
    
    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 64, weight: UIFont.Weight.thin)
        label.textColor = .white
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = createBlankLabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var dayDetailLabel: UILabel = {
        let label = createBlankLabel()
        label.font = createSmallCapsFont(withTextStyle: .callout)
        
        return label
    }()
    
    private lazy var highTemperatureLabel: UILabel = {
        let label = createBlankLabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var lowTemperatureLabel: UILabel = {
        let label = createBlankLabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var topConstraint: NSLayoutConstraint = {
        let constraint = dayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: defaultHeight)
        return constraint
    }()
    
    var viewModel: ConditionsViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            currentTemperatureLabel.text = viewModel.currentTemperature
            highTemperatureLabel.text = viewModel.highTemperature
            lowTemperatureLabel.text = viewModel.lowTemperature
            
            dayLabel.text = viewModel.day
            dayDetailLabel.text = "TODAY"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(currentTemperatureLabel)
        view.addSubview(dayLabel)
        view.addSubview(dayDetailLabel)
        view.addSubview(highTemperatureLabel)
        view.addSubview(lowTemperatureLabel)
        
        applyConstraints()
    }
    
    func adjustAppearence(using contentOffset: CGPoint) {
        currentTemperatureLabel.alpha = alphaPercent(using: contentOffset)
        dayLabel.alpha = alphaPercent(using: contentOffset)
        dayDetailLabel.alpha = alphaPercent(using: contentOffset)
        highTemperatureLabel.alpha = alphaPercent(using: contentOffset)
        lowTemperatureLabel.alpha = alphaPercent(using: contentOffset)
        
        // moves the group of labels up and down
        topConstraint.constant = calculateBottomConstraint(using: contentOffset)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentTemperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            
            dayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dayLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            topConstraint,
            
            dayDetailLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 6),
            dayDetailLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            
            highTemperatureLabel.trailingAnchor.constraint(equalTo: lowTemperatureLabel.leadingAnchor, constant: -8),
            highTemperatureLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            
            lowTemperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lowTemperatureLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor)
        ])
    }
}

// the default height of the temperature view
private let defaultHeight: CGFloat = 121.0

private func alphaPercent(using contentOffset: CGPoint) -> CGFloat {
    if contentOffset.y <= 0.0 {
        return 1.0
    } else if contentOffset.y > 0.0 && contentOffset.y < 100.0 {
        return 1.0 - (contentOffset.y / 100.0)
    } else {
        return 0.0
    }
}

private func calculateBottomConstraint(using contentOffset: CGPoint) -> CGFloat {
    // the minimum distance the view must scroll view before changing appearence
    // in this case, above the temperature view, the header view scrolls for minContentOffset
    // before stopping, and allowing the temperature view to change appe
    let minContentOffset: CGFloat = 15.0
    
    // the maximum distance the view can scroll view before it *stops* changing appearence
    let maxContentOffset = Size.temperatureViewMaxContentOffset
    
    if contentOffset.y <= minContentOffset {
        return defaultHeight
    } else if contentOffset.y > minContentOffset && contentOffset.y < maxContentOffset {
        let difference = contentOffset.y - Size.headerViewContentOffsetThreshold
        return defaultHeight - difference
    } else {
        let difference = maxContentOffset - Size.headerViewContentOffsetThreshold
        return defaultHeight - difference;
    }
}
