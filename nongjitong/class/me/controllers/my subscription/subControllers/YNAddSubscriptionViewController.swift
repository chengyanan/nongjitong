//
//  YNAddSubscriptionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddSubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNSelectedCategoryViewControllerDelegate {

    var tableView: UITableView?
    
    var model = YNSubscriptionModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加订阅"
        
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNAddSubscriptionTableViewCell
        
        if cell == nil {
            
            cell = YNAddSubscriptionTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        if indexPath.section == 0 {
        
            cell?.name = "品类名称"
            
            if model.product_name != "" {
            
                cell?.content = model.product_name
                
            } else {
            
                cell?.content = "请选择品类"
            }
            
            
            
        } else if indexPath.section == 1 {
        
            cell?.name = "规模"
            
            if model.range != "" {
            
                cell?.content = model.range
                
            } else {
            
                 cell?.content = "请选择规模"
            }
            
        } else if indexPath.section == 2 {
            
            cell?.name = "地区"
            
            if model.area_id != "" {
                
                cell?.content = model.address
            } else {
            
                 cell?.content = "请选择地区"
            }
           
        }
        
        return cell!
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 12
    }
    
    //MARK: tableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
        
            //选择品类
            let selectCatagoryVc = YNSelectedCategoryViewController()
            selectCatagoryVc.delegate = self
            self.navigationController?.pushViewController(selectCatagoryVc, animated: true)
        }
        
    }
    
    //MARK: YNSelectedCategoryViewControllerDelegate
    func selectedCategoryDidSelectedProduct(product: YNCategoryModel) {
        
        self.model.product_name = product.class_name
        
        self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
}
