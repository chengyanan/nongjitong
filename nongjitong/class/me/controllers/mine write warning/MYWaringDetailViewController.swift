//
//  MYWaringDetailViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/5.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class MYWaringDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
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
        
        
        let userid = kUser_ID() as? String
        
        if let _ = userid {
            
            //已登陆请求数据
            let params: [String: String?] = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "Warning",
                "a": "getWarning",
                "warning_id": self.resaultModel?.id,
                "user_id": userid
            ]
            
            let progress = YNProgressHUD().showWaitingToView(self.view)
            
            Network.post(kURL, params: params, success: { (data, response, error) -> Void in
                
                progress.hideUsingAnimation()
                
                let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
//                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let resaultData = json["data"] as! NSDictionary
                        
                        let resaultModel = YNEarlyToMyProgramModel(dict: resaultData)
                        
                        self.model = resaultModel
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
//                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
                
                }) { (error) -> Void in
                    
                    progress.hideUsingAnimation()
                    YNProgressHUD().showText("加载失败", toView: self.view)
            }
            
            
            
        } else {
            
            //没有登录
            YNProgressHUD().showText("请先登录", toView: self.view)
            
        }
        
        
        
    }
    
    var tableView: UITableView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我写的预警"
        
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
            
            return "订阅内容"
            
        }
    
        return "预警内容"
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
        }
            
        if let _ = self.model?.contentHeight {
            
            return self.model!.contentHeight!
        }
        
        return 0
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
            
            if let _ = subscribeModel {
                
                cell?.textLabel?.text = "\(subscribeModel!.class_name!)  \(subscribeModel!.city_name!)  \(subscribeModel!.range!)"
            }
            
            return cell!
            
        }
        
        
        if self.model?.photos?.count > 0 {
        
            let idenfier = "CELL_ToMyProgram_WithImage"
            var cell = tableView.dequeueReusableCellWithIdentifier(idenfier) as? YNSearchSolutionWithImageCell
            
            if cell == nil {
                
                cell = YNSearchSolutionWithImageCell(style: .Default, reuseIdentifier: idenfier)
            }
            
            cell?.earlyToMyProgramModel = self.model
            
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
