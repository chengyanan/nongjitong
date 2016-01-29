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
        
        let tempView = UITableView(frame: CGRectZero, style: .Plain)
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        
        if indexPath.row == 0 {
        
            if let _ = self.modelDetail {
            
                return modelDetail!.membersHeight
            }
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let identifier = "Cell_circle_members"
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNMembersTableViewCell
            
            if cell == nil {
                
                cell = YNMembersTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            if let _ = self.modelDetail {
            
                cell?.dataArray = modelDetail!.users
            }
            
            return cell!
            
        }
        
        let identifier = "Cell_circle"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
        
    }
    
    //MARK: tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
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
