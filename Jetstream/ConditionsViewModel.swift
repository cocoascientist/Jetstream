//
//  ConditionsViewModel.swift
//  Jetstream
//
//  Created by Andrew Shepard on 1/20/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit

class ConditionsViewModel: NSObject, UITableViewDataSource {
    
    weak var tableView: UITableView? {
        didSet {
            self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "test"
        
        // 3
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
}
