//
//  ViewController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/19/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var conditionsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityLabel.text = "Loading..."
        
        let request = OpenWeatherMapAPI.Seattle.request()
        let task = NetworkController.task(request, result: { (result) -> Void in
            switch result {
            case .Success(let data):
                let jsonResult = data().toJSON()
                switch jsonResult {
                case .Success(let json):
                    if let weather = Weather.weatherFromJSON(json()) {
                        self.cityLabel.text = weather.name
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
