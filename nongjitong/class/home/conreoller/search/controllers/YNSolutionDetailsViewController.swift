//
//  YNSolutionDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//暂时不需要这个

import UIKit

class YNSolutionDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var model: YNSearchSolutionListModel? {
        
        didSet {
            
            self.tableView?.reloadData()
        }
    }
    
    var resaultModel:YNSearchSolutionListModel? {
        
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
                "c": "DocPrograms",
                "a": "readPrograms",
                "programs_id": self.resaultModel?.id,
                "user_id": userid
            ]
            
            let progress = YNProgressHUD().showWaitingToView(self.view)
            
            Network.post(kURL, params: params, success: { (data, response, error) -> Void in
                
                progress.hideUsingAnimation()
                
                let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let resaultData = json["data"] as! NSDictionary
                        
                        let resaultModel = YNSearchSolutionListModel(dict: resaultData)
                        
                        self.model = resaultModel
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            print(msg)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "方案详情"
        
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
            
            return "方案针对的文章"
            
        }
        
        return "方案内容"
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
        }
        
        if let _ = self.model?.height {
            
            return self.model!.height!
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "CELL_MyScrible"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            if let _ = self.model?.doc_title {
            
                 cell?.textLabel?.text = "\(self.model!.doc_title!)"
            }
            
            return cell!
            
        }
        
        if self.model?.photos?.count > 0 {
        
            let identify: String = "Cell_Search_Resault_listWithImage"
            var cell: YNSearchSolutionWithImageCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionWithImageCell
            
            if cell == nil {
                
                cell = YNSearchSolutionWithImageCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                
            }
            
            cell?.solutionModel = self.model
            
            return cell!
        }
        
        let idenfier = "CELL_ToMyProgram"
        var cell = tableView.dequeueReusableCellWithIdentifier(idenfier) as? YNSearchSolutionCell
        
        if cell == nil {
            
            cell = YNSearchSolutionCell(style: .Default, reuseIdentifier: idenfier)
        }
        
        cell?.solutionModel = self.model
        
        return cell!
        
    }
    
    
    
}
