//
//  YNMySubscriptionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//我的订阅

import UIKit

class YNMySubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    var addSubscriptionButton: UIButton?
    
    
    //MARK: life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        
        setInterface()
        setLayout()
    }
    
    func setLayout() {
        
        //addSubscriptionButton
        Layout().addTopConstraint(addSubscriptionButton!, toView: self.view, multiplier: 1, constant: 76)
        Layout().addLeftConstraint(addSubscriptionButton!, toView: self.view, multiplier: 1, constant: 16)
        Layout().addRightConstraint(addSubscriptionButton!, toView: self.view, multiplier: 1, constant: -16)
        Layout().addHeightConstraint(addSubscriptionButton!, toView: nil, multiplier: 0, constant: 44)
        
    
        //tableView
        Layout().addTopToBottomConstraint(tableView!, toView: addSubscriptionButton!, multiplier: 1, constant: 10)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
    }
    
    func setInterface() {
        
        //addSubscriptionButton
        let tempButton = UIButton()
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.layer.cornerRadius = 3
        tempButton.clipsToBounds = true
        tempButton.layer.borderWidth = 1
        tempButton.layer.borderColor = kRGBA(88, g: 190, b: 183, a: 1).CGColor
        tempButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        tempButton.setImage(UIImage(named: "addNewSubscription"), forState: .Normal)
        tempButton.setTitle("添加订阅", forState: .Normal)
        tempButton.setTitleColor(kRGBA(88, g: 190, b: 183, a: 1), forState: .Normal)
        tempButton.addTarget(self, action: "addButtonDidClick", forControlEvents: .TouchUpInside)
        self.view.addSubview(tempButton)
        self.addSubscriptionButton = tempButton
    
        //tableView
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableFooterView = UIView()
        tempTableView.rowHeight = 58
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.showsVerticalScrollIndicator = false
        tempTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
    }
    
    func addButtonDidClick() {
        
        //TODO:添加订阅
        let vc = YNAddSubscriptionViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_My_Subscription"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSunscriptionTableViewCell
        
        if cell == nil {
        
            cell = YNSunscriptionTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        return cell!
    }
    
   
    
}
