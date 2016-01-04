//
//  YNCheckMyProogramViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNCheckMyProogramViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var model: YNEarlyToMyProgramModel? {
    
        didSet {
        
            self.tableView?.reloadData()
        }
    }
    
    var resaultModel:YNEarlyToMyProgramModel? {
    
        didSet {
        
            self.loaddata()
        }
    }
    
    func loaddata() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Warning",
            "a": "getWarning",
            "warning_id": self.resaultModel?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let resaultData = json["data"] as! NSArray
                    
                    if resaultData.count > 0 {
                        
                        var tempArray = [YNEarlyToMyProgramModel]()
                        
                        for item in resaultData {
                            
                            let dict = item as! NSDictionary
                            
                            let resaultModel = YNEarlyToMyProgramModel(dict: dict)
                            
                            tempArray.append(resaultModel)
                        }
                        
                        self.resaultModel = tempArray[0]
                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("还没有别人给我写的预警方案", toView: self.view)
                        
                    }
                    
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
    }
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "方案"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        self.view.addSubview(tableView!)
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
        
            return "我的订阅"
        }
        
        return "解决方案"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
        }
        
        return self.model!.contentHeight!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.model {
        
            if section == 0 {
                
                return model!.subscribe.count
                
            } else {
            
                return 1
            }
            
        }
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let identify = "CELL_MyScrible"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
            
                cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            let subscribeModel = self.model?.subscribe[indexPath.row]
            
            cell?.textLabel?.text = "\(subscribeModel!.class_name!)  \(subscribeModel!.city_name!)  \(subscribeModel!.range!)"
            
            return cell!
            
        }
        
        let idenfier = "CELL_ToMyProgram"
        var cell = tableView.dequeueReusableCellWithIdentifier(idenfier) as? YNSearchSolutionCell
        
        if cell == nil {
            
            cell = YNSearchSolutionCell(style: .Default, reuseIdentifier: idenfier)
        }
        
        cell?.earlyToMyProgramModel = self.model
        
        return cell!
        
    }
    
    
    
}
