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
    
    var solutionType: SolutionType = .Article
    
    var solutionModel: YNSearchSolutionListModel? {
    
        didSet {
            
            self.tableView?.reloadData()
            
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
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let resaultData = json["data"] as! NSDictionary
                    
                        let resaultModel = YNEarlyToMyProgramModel(dict: resaultData)
                        
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            if solutionType == SolutionType.Article {
            
                return "订阅内容"
                
            } else {
            
                return "方案针对的文章标题"
            }
            
            
        }
        
        if solutionType == SolutionType.Article {
            
            return "解决方案"
            
        } else {
            
            return "方案内容"
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
        }
        
        if solutionType == SolutionType.Article {
        
            if let _ = self.model?.contentHeight {
                
                return self.model!.contentHeight!
            }
            
        } else {
        
            if let _ = self.solutionModel?.height {
            
                return self.solutionModel!.height!
            }
        }
    
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if solutionType == .Article {

            if let _ = self.model {
                
                if section == 0 {
                    
                    return model!.subscribe.count
                    
                } else {
                    
                    return 1
                }
                
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
            
            if solutionType == .Article {
            
                let subscribeModel = self.model?.subscribe[indexPath.row]
                
                if let _ = subscribeModel {
                    
                    cell?.textLabel?.text = "\(subscribeModel!.class_name!)  \(subscribeModel!.city_name!)  \(subscribeModel!.range!)"
                }
                
            } else {
                
                if let _ = self.solutionModel?.doc_title {
                
                     cell?.textLabel?.text = self.solutionModel!.doc_title!
                }
            
               
            }
        
                return cell!
            
        }
        
        let idenfier = "CELL_ToMyProgram"
        var cell = tableView.dequeueReusableCellWithIdentifier(idenfier) as? YNSearchSolutionCell
        
        if cell == nil {
            
            cell = YNSearchSolutionCell(style: .Default, reuseIdentifier: idenfier)
        }
        
        if solutionType == .Article {
        
             cell?.earlyToMyProgramModel = self.model
            
        } else if solutionType == SolutionType.MyselfArticle {
        
            cell?.solutionModel = self.solutionModel
            
        } else {
        
            cell?.earlyToMyProgramModel = self.model
        }
        
        return cell!
        
    }
    
    
    
}
