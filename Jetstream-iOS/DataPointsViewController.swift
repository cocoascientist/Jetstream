//
//  DataPointsViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 2/3/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import JetstreamKit

class DataPointsViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    
    var viewModel: DataPointsViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            stackView.removeAllArrangedSubviews()
            addSubviewsToStackView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.alignment = .center
        stackView.distribution = .fill
        
        addSubviewsToStackView()
    }
    
    fileprivate func addSubviewsToStackView() {
        guard let dataPointGroups = viewModel?.dataPointGroups else { return }
        
        for group in dataPointGroups {
            let dataPointsView = DataPointsView()
            dataPointsView.dataPointGroup = group
            
            stackView.addArrangedSubview(dataPointsView)
            
            let width = NSLayoutConstraint(item: dataPointsView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1, constant: 0)
            
            self.view.addConstraint(width)
        }
    }
}
