//
//  YNAddSubscriptionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddSubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    
    var model = YNSubscriptionModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInterface()
        setLayout()
    }
    
    func setLayout() {
        
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 10)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
    }
    
    func setInterface() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableFooterView = UIView()
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.showsVerticalScrollIndicator = false
        tempTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
    }
    
    
    //MARK:UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_My_Subscription"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        if indexPath.section == 0 {
        
            cell?.textLabel?.text = "品类名称"
            
        } else if indexPath.section == 1 {
        
            cell?.textLabel?.text = "规模"
            
        } else if indexPath.section == 2 {
            
            cell?.textLabel?.text = "地区"
        }
        
        return cell!
    }

//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        
//        return 30
//        
//    }
    
}
