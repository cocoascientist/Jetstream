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
        let label = self.dayLabel
        let constraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: defaultHeight)
        
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
        applyCurrentTemperatureLabelConstaints()
        
        applyDayLabelConstraints()
        applyDayDetailLabelConstraints()
        
        applyHighTemperatureLabelConstraints()
        applyLowTemperatureLabelConstraints()
    }
    
    private func applyCurrentTemperatureLabelConstaints() {
        let centerX = NSLayoutConstraint(item: currentTemperatureLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: currentTemperatureLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8)
        
        NSLayoutConstraint.activate([centerX, top])
    }
    
    private func applyDayLabelConstraints() {
        let leading = NSLayoutConstraint(item: dayLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16)
        let bottom = NSLayoutConstraint(item: dayLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -8)
        
        NSLayoutConstraint.activate([leading, bottom, topConstraint])
    }
    
    private func applyDayDetailLabelConstraints() {
        let leading = NSLayoutConstraint(item: dayDetailLabel, attribute: .leading, relatedBy: .equal, toItem: dayLabel, attribute: .trailing, multiplier: 1, constant: 6)
        let bottom = NSLayoutConstraint(item: dayDetailLabel, attribute: .bottom, relatedBy: .equal, toItem: dayLabel, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([leading, bottom])
    }
    
    private func applyHighTemperatureLabelConstraints() {
        let trailing = NSLayoutConstraint(item: highTemperatureLabel, attribute: .trailing, relatedBy: .equal, toItem: lowTemperatureLabel, attribute: .leading, multiplier: 1, constant: -8)
        let bottom = NSLayoutConstraint(item: highTemperatureLabel, attribute: .bottom, relatedBy: .equal, toItem: dayLabel, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([trailing, bottom])
    }
    
    private func applyLowTemperatureLabelConstraints() {
        let trailing = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -16)
        let bottom = NSLayoutConstraint(item: lowTemperatureLabel, attribute: .bottom, relatedBy: .equal, toItem: dayLabel, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([trailing, bottom])
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
