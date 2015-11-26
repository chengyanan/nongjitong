//
//  YNAddSubscriptionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddSubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNSelectedCategoryViewControllerDelegate, YNScaleViewDelegate, YNSelectAreaViewControllerDelegate {
    
    var tableView: UITableView?
    var model = YNSubscriptionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加订阅"
        
        addRightItem()
        setInterface()
        setLayout()
    }
    
    func addRightItem() {
    
        let rightBarButtonItem = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemDidClick")
        
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func rightBarButtonItemDidClick() {
        
        if model.class_name == "" {
        
            YNProgressHUD().showText("请选择品类", toView: self.view)
            
        } else {
        
            if model.range == "" {
            
                YNProgressHUD().showText("请选择规模", toView: self.view)
                
            } else {
            
                
                if model.area_id == "" {
                
                    YNProgressHUD().showText("请选择规模", toView: self.view)
                    
                } else {
                    
                    //信息完整, 上传到服务器
                    addSubcribe()
                }
                
            }
        }
        
    }
    
    //MARK: 上传服务器
    func addSubcribe() {
    
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        YNHttpSubscription().addSubcribe(self.model, successFull: { (json) -> Void in
            
                progress.hideUsingAnimation()
            
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
//                        print(json)
                        
//                        let tempdata = json["data"] as! String
                        
                        
                      YNProgressHUD().showText("添加成功", toView: self.view)
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            
                           
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                            
                            print("\n \(msg) \n")
                        }
                    }
                    
                }
            
            
            }, failureFul: { (error) -> Void in
                
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
                
        })
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
//        tempTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
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
            
            if model.class_name != "" {
            
                cell?.content = model.class_name
                
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
            
        } else if indexPath.section == 1 {
        
            //选择规模
            let scaleView = YNScaleView()
            scaleView.delegate = self
            scaleView.show()
            
        } else if indexPath.section == 2 {
        
            //选择地区
            let vc = YNSelectAreaViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
   
    //MARK: YNSelectedCategoryViewControllerDelegate
    func selectedCategoryDidSelectedProduct(product: YNCategoryModel) {
        
        self.model.class_name = product.class_name
        self.model.class_id = product.id
        self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    //MARK: YNScaleViewDelegate
    func scaleViewDoneButtonDidClick(title: String) {
        
        self.model.range = title
        
        self.tableView?.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
    }
    
    //MARK: YNSelectAreaViewControllerDelegate
    func selectAreaViewControllerDidSelectArea(model: YNBaseCityModel) {
        
        self.model.area_id = model.id
        self.model.address = model.city_name
        
        self.tableView?.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
    }
    
}
