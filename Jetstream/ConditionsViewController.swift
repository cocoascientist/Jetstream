//
//  ConditionsViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ConditionsViewController: UIViewController {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var conditionsLabel: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    let viewModel = ConditionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        self.tableView.pagingEnabled = true
        
        self.viewModel.tableView = self.tableView
        self.tableView.dataSource = self.viewModel
        
        let request = OpenWeatherMapAPI.Seattle.request()
        let task = NetworkController.task(request, result: { (result) -> Void in
            switch result {
            case .Success(let data):
                let jsonResult = data().toJSON()
                switch jsonResult {
                case .Success(let json):
                    if let weather = Weather.weatherFromJSON(json()) {
                        println("success: \(weather)")
                    }
                case .Failure(let reason):
                    println("error: \(reason.description)")
                }
            case .Failure(let reason):
                println("error: \(reason.description)")
            }
        })
        
        task.resume()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = UIImage(named: "placeholder.jpg") {
            self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
            self.backgroundImageView.image = image
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let effectView = UIVisualEffectView(effect: blurEffect)
            
            effectView.frame = self.backgroundImageView.bounds
//            self.backgroundImageView.addSubview(effectView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
