//
//  HeaderViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/2/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

final class HeaderViewController: UIViewController {
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var topConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.cityLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 30)
        return constraint
    }()
    
    var viewModel: ConditionsViewModel? {
        didSet {
            self.cityLabel.text = viewModel?.cityName ?? ""
            self.summaryLabel.text = viewModel?.summary ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(cityLabel)
        view.addSubview(summaryLabel)
        
        applyConstraints()
        
        cityLabel.text = "City Name"
        summaryLabel.text = "Summary"
        
        cityLabel.textColor = .white
        summaryLabel.textColor = .white
        
        configureView()
        
        self.view.backgroundColor = .clear
        
        let name = UIContentSizeCategory.didChangeNotification
        NotificationCenter.default.addObserver(self, selector: #selector(handleSizeChange(notification:)), name: name, object: nil)
    }
    
    func adjustAppearence(using contentOffset: CGPoint) {
        topConstraint.constant = calculateTopConstraint(using: contentOffset)
    }
    
    private func applyConstraints() {
        applyCityLabelConstraints()
        applySummaryLabelConstraints()
    }
    
    private func applyCityLabelConstraints() {
        let centerX = NSLayoutConstraint(item: cityLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([centerX, topConstraint])
    }
    
    private func applySummaryLabelConstraints() {
        let centerX = NSLayoutConstraint(item: summaryLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: summaryLabel, attribute: .top, relatedBy: .equal, toItem: cityLabel, attribute: .bottom, multiplier: 1, constant: 3)
        let bottom = NSLayoutConstraint(item: summaryLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 5)
        
        NSLayoutConstraint.activate([centerX, top, bottom])
    }
    
    @objc func handleSizeChange(notification: Notification) {
        configureView()
    }
    
    private func configureView() {
        cityLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

fileprivate func calculateTopConstraint(using contentOffset: CGPoint) -> CGFloat {
    if contentOffset.y <= 0.0 {
        return Size.headerViewMaxTopConstraint
    } else if contentOffset.y > 0.0 && contentOffset.y < Size.headerViewContentOffsetThreshold {
        return Size.headerViewMaxTopConstraint - contentOffset.y
    } else {
        return Size.headerViewMinTopConstraint
    }
}
