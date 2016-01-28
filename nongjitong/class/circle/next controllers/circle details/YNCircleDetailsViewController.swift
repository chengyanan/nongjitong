//
//  YNCircleDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNCircleDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var model: YNCircleModel? {
    
        didSet {
        
            self.title = model?.title!
        }
    }
    
    let tableView: UITableView = {
        
        let tempView = UITableView(frame: CGRectZero, style: .Plain)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        return tempView
        
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "Cell_circle"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
        
    }
    
    //MARK: tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    
    
    
}
