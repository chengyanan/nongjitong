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
    
    var dataArray = [YNSubscriptionModel]()
    
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
        
        self.title = "我的订阅"
        self.view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        
        self.setInterface()
        self.setLayout()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
         getData()
    }
    
    //MARK: 加载数据
    func getData() {
    
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        YNHttpSubscription().getSubcribe({ (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    print(json)
                    
                    let tempdata = json["data"] as! NSArray
                
                    self.dataArray.removeAll()
                    
                    for item in tempdata {
                    
                        let model = YNSubscriptionModel(dict: item as! NSDictionary)
                        self.dataArray.append(model)
                    }
                    
                   self.tableView?.reloadData()
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
        }
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
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableFooterView = UIView()
        tempTableView.rowHeight = 50
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_My_Subscription"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSunscriptionTableViewCell
        
        if cell == nil {
        
            cell = YNSunscriptionTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.model = self.dataArray[indexPath.section]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 11
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
   //MARK:UITableViewDelagate
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
        
            delSubcribeWithModel(self.dataArray[indexPath.row], indexPath: indexPath)
        }
    }
    
    func delSubcribeWithModel(model: YNSubscriptionModel, indexPath: NSIndexPath) {
    
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpSubscription().delSubcribe(model, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    print(json)

                    //删除成功
                    self.dataArray.removeAtIndex(indexPath.row)
                    self.tableView?.reloadData()
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
        }
    }
    
}
