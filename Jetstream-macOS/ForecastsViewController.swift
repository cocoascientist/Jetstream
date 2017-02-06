//
//  ForecastViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 11/8/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Cocoa
import JetstreamKit

class ForecastsViewController: NSViewController {
    
    @IBOutlet var stackView: NSStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            guard let model = representedObject as? ForecastsViewModel else { return }
            
            stackView.removeArrangedSubviews()
            
            model.dailyForecasts.forEach { viewModel in
                let forecastView = ForecastView(frame: .zero)
                forecastView.viewModel = viewModel
                
                stackView.addArrangedSubview(forecastView)
            }
        }
    }
}

extension NSStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
