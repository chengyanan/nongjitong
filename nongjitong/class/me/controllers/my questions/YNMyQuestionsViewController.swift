//
//  YNMyQuestionsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/17.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNMyQuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let tableView: UITableView = {
        
        let tempTableView = UITableView(frame: CGRectZero, style: .Plain)
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        return tempTableView
        
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的提问"
        
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setLayout()
    }
    
    func setLayout() {
    
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
    }
    
   //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "CELL_MyQuestion"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
    }
    
    
    
}
