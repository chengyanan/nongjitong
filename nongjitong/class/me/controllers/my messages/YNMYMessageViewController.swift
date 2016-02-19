//
//  YNMYMessageViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNMYMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var page = 1
    let page_size = 20
    
    var dataArray = [YNMessageModel]()
    
    //是否显示加载更多
    var isShowLoadMore = false {
        
        didSet {
            
            if isShowLoadMore {
                
                self.tableView.addFooterRefresh()
                
            } else {
                
                self.tableView.removeFooterRefresh()
            }
        }
    }
    
    var segmentSelectedIndex = 0
    
    let segmentControl: UISegmentedControl = {
        
        let tempView = UISegmentedControl(items: ["我发出的消息", "我收到的消息"])
        tempView.selectedSegmentIndex = 0
        return tempView
        
    }()

    let tableView: UITableView = {
        
        let tempView = UITableView(frame: CGRectZero, style: .Plain)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        return tempView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = segmentControl
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        
        loaddata()
        
        segmentControl.addTarget(self, action: "segmentClick:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //MARK: event response
    func segmentClick(sender: UISegmentedControl) {
    
        if sender.selectedSegmentIndex == segmentSelectedIndex {
        
            //相等就什么也不做
        } else {
        
            self.page = 1
            self.segmentSelectedIndex = segmentControl.selectedSegmentIndex
            
            //不相等重新加载数据
            if segmentControl.selectedSegmentIndex == 0 {
            
                //加载我发出的消息
                loaddata()
                
            } else if segmentControl.selectedSegmentIndex == 1 {
            
                //加载别人发给我的消息
                sendMessageToMe()
            }
            
            
            
        }
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return dataArray[indexPath.row].cellheight!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if segmentSelectedIndex == 0 {
        
            let identifier = "Cell_circle_MySendMessage"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNMySendMessageTableViewCell
            
            if cell == nil {
                
                cell = YNMySendMessageTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            cell?.model = dataArray[indexPath.row]
            
            return cell!
        }
        
        let identifier = "Cell_circle_SendToMeMessage"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNOtherSendMessageTableViewCell
        
        if cell == nil {
            
            cell = YNOtherSendMessageTableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.model = dataArray[indexPath.row]
        
        return cell!
        
    }
    
    //MARK: tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    //MARK: 我收到的消息
    func sendMessageToMe() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupUserVerifyMessage",
            "a": "getToMeList",
            "page": "\(page)",
            "page_size": "\(page_size)",
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
                        
                        let tempArray = json["data"] as? NSArray
                        
                        if tempArray?.count > 0 {
                            
                            
                            if tempArray?.count < self.page_size {
                                
                                self.isShowLoadMore = false
                                
                            } else {
                                
                                self.isShowLoadMore = true
                            }
                            
                            if self.page == 1 {
                                
                                self.dataArray.removeAll()
                            }
                            
                            for item in tempArray! {
                                
                                
                                let model = YNMessageModel(dict: item as! NSDictionary)
                                
                                self.dataArray.append(model)
                                
                            }
                            
                            self.tableView.reloadData()
                            
                        } else {
                            
                            YNProgressHUD().showText("没有数据", toView: self.view)
                            
                        }
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
                
            } catch {
                
                YNProgressHUD().showText("请求失败", toView: self.view)
                
            }
            
            
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
                
                if self.page == 1 {
                    
                    self.dataArray.removeAll()
                    
                    self.tableView.reloadData()
                }
        }
        
        
    }
    
    //MARK: 我发出的消息
    func loaddata() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupUserVerifyMessage",
            "a": "getISendList",
            "page": "\(page)",
            "page_size": "\(page_size)",
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
                        
                        let tempArray = json["data"] as? NSArray
                        
                        if tempArray?.count > 0 {
                            
                            
                            if tempArray?.count < self.page_size {
                                
                                self.isShowLoadMore = false
                                
                            } else {
                                
                                self.isShowLoadMore = true
                            }
                            
                            if self.page == 1 {
                                
                                self.dataArray.removeAll()
                            }
                            
                            for item in tempArray! {
                                
                                
                                let model = YNMessageModel(dict: item as! NSDictionary)
                                
                                self.dataArray.append(model)
                                
                            }
                            
                            self.tableView.reloadData()
                            
                        } else {
                            
                            YNProgressHUD().showText("没有数据", toView: self.view)
                            
                        }
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
                
            } catch {
            
                YNProgressHUD().showText("请求失败", toView: self.view)
                
            }
            
            
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
    }
    
}
