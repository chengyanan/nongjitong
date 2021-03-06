//
//  YNCircleDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNCircleDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var model: YNCircleModel? {
    
        didSet {
        
            self.title = model?.title!
        }
    }
    
    var modelDetail: YNCircleDetailModel? {
    
        didSet {
        
            self.tableView.reloadData()
        }
    }
    
    let tableView: UITableView = {
        
        let tempView = UITableView(frame: CGRectZero, style: .Grouped)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        return tempView
        
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        
        loaddata()
    }
    
    //MARK:UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        
        if indexPath.section == 0 {
        
            if let _ = self.modelDetail {
            
                return modelDetail!.membersHeight
            }
            
        } else if indexPath.section == 1 {
            
            if let _ = self.modelDetail {
                
                return modelDetail!.announcementHeight
            }
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let identifier = "Cell_circle_members"
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNMembersTableViewCell
            
            if cell == nil {
                
                cell = YNMembersTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            if let _ = self.modelDetail {
            
                cell?.dataArray = modelDetail!.users
            }
            
            return cell!
            
        } else if indexPath.section == 1 {
        
            let identifier = "Cell_circle"
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNAnnounceTableViewCell
            
            if cell == nil {
                
                cell = YNAnnounceTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            if let _ = self.modelDetail {
                
                cell?.textStr = modelDetail?.announcement
                
            }
            
            cell?.selectionStyle = .None
            
            return cell!
            
        }
        
        let identifier = "Cell_circle_ quit"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "退出圈子"
        cell?.textLabel?.font = UIFont.systemFontOfSize(13)
        cell?.selectionStyle = .None
        
        return cell!
        
        
    }
    
    //MARK: tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
        
            //退出圈子
            
            if kUser_ID() as? String == model?.user_id {
            
                //自己建的圈子不能退出
                YNProgressHUD().showText("您不能退出自己建的圈子", toView: self.view)
                
            } else {
            
                self.quitCircle()
            }
            
            
            
        }
        
    }
    
    
    //MARK: quit circle
    func quitCircle() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupUser",
            "a": "exitGroup",
            "group_id": model?.id,
            "user_id": kUser_ID() as? String
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        //退出成功
                        YNProgressHUD().showText("退出成功", toView: self.view)
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            
                            let toViewIndex = self.navigationController!.childViewControllers.count - 2
                            
                            let vc = self.navigationController?.childViewControllers[toViewIndex]
                            
                            self.navigationController?.popToViewController(vc!, animated: true)
                            
                        }
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
            } catch {
                
                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
    
    
    
    }
    
    
    //MARK: loadData
    func loaddata() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Group",
            "a": "getDetail",
            "group_id": model?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                       let tempDict = json["data"] as? NSDictionary
                        
                       let tempModel = YNCircleDetailModel(dict: tempDict!)
                        
                       self.modelDetail = tempModel
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
            } catch {
                
                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
}
