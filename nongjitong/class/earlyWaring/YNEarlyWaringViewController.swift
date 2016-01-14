//
//  YNEarlyWaringViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//预警

import UIKit

class YNEarlyWaringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var page: Int = 1
    var pagecount: Int = 20
    var isFirstLoadData = true
    var tempResaultArray = [YNEarlyToMyProgramModel]()
    
    var resaultArray = [YNEarlyToMyProgramModel]() {
    
        didSet {
        
            self.tableView.reloadData()
        }
    }
    
    var rightItem: UIBarButtonItem?
    
    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        
        self.rightItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "login")
        navigationItem.rightBarButtonItem = rightItem
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.addHeaderRefreshWithActionHandler { () -> Void in
            
            self.loadData()
        }
        
        self.tableView.addFooterRefreshWithActionHandler { () -> Void in
            
            self.page++
            self.loadData()
            
        }
        
        //登录加载数据
        loadData()
    }
    
    func login() {
    
        //没有登录 跳登录界面
        let signInVc = YNSignInViewController()

        let navVc = UINavigationController(rootViewController: signInVc)

        self.presentViewController(navVc, animated: true, completion: { () -> Void in
            
        })
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView?.removeRefresh()
    }

    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tableView?.addRefresh()
        
        let uesrId = kUser_ID()
        
        if let _ = uesrId {
            
            navigationItem.rightBarButtonItem = nil
            
//           //登录加载数据
//            loadData()
            
        } else {
        
            navigationItem.rightBarButtonItem = self.rightItem
            //没有登录
            self.resaultArray = [YNEarlyToMyProgramModel]()
            
            YNProgressHUD().showText("请先登录", toView: self.view)
            
        }
        
    }
    
    //MARK: event response
    @IBAction func leftbarButtonClick(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
        
    }
    
    @IBAction func selectChanged(sender: AnyObject) {
        
        self.page = 1
        self.tempResaultArray.removeAll()
        
        loadData()
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.resaultArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.segmentController.selectedSegmentIndex == 0 {
        
            return self.resaultArray[indexPath.row].summaryHeight!
        }
        
        if self.resaultArray[indexPath.row].subscribe.count >= 2 {
        
            return 86
            
        } else {
        
            return 60
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if segmentController.selectedSegmentIndex == 0 {
            
            let model = self.resaultArray[indexPath.row]
            
            if model.photos?.count > 0 {
            
                let identify = "CELL_Waring_MyWithImage"
                var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionWithImageCell
                
                if cell == nil {
                    
                    cell = YNSearchSolutionWithImageCell(style: .Default, reuseIdentifier: identify)
                    
                }
                
                cell?.earlyToMyProgramModel = self.resaultArray[indexPath.row]
                
                return cell!
                
            }
        
            let identify = "CELL_Waring_My"
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionCell
            
            if cell == nil {
                
                cell = YNSearchSolutionCell(style: .Default, reuseIdentifier: identify)
                
            }
            
            cell?.earlyToMyProgramModel = self.resaultArray[indexPath.row]
                       
            return cell!
        }
        
        let identify = "CELL_OtherSubscript"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNEarlyOtherSubscribeCell
        
        if cell == nil {
            
            cell = YNEarlyOtherSubscribeCell(style: .Default, reuseIdentifier: identify)
            
        }
        
        cell?.model = self.resaultArray[indexPath.row]
        
        return cell!
        
    }

    //MARK:tableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.segmentController.selectedSegmentIndex == 0 {
        
            let vc = YNCheckMyProogramViewController()
            
            vc.resaultModel = self.resaultArray[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
        
            let vc = YNWriteProgramToOtherViewController()
            vc.model = self.resaultArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    //MARK: load data
    func loadData() {
        
        let userid = kUser_ID() as? String
    
        if let _ = userid {
        
            //已登陆请求数据
            loadMYProGramFromServer(userid!)
            
        } else {
        
            //没有登录
            self.resaultArray = [YNEarlyToMyProgramModel]()
            
            YNProgressHUD().showText("请先登录", toView: self.view)
            
        }
        
    }
    
    func loadMYProGramFromServer(userid: String) {
    
        let params: [String: String?]
        
        if segmentController.selectedSegmentIndex == 0 {
            
            //加载给我的预警方案
            params = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "Warning",
                "a": "getToMe",
                "user_id": userid,
                "page": String(self.page),
                "page_size": String(self.pagecount)
            ]
            
        } else {
            
            //加载别人的订阅选项
            params = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "User",
                "a": "getSubscribeList",
                "user_id": userid,
                "page": String(self.page),
                "page_size": String(self.pagecount)
            ]
            
        }
        
        
        var progress : ProgressHUD?
        
        if isFirstLoadData {
            
            progress = YNProgressHUD().showWaitingToView(self.view)
            
        }
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            self.tableView?.stopRefresh()
            
            if self.isFirstLoadData {
                
                progress!.hideUsingAnimation()
                
                self.isFirstLoadData = false
            }
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
//            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let resaultData = json["data"] as! NSArray
                    
                    if resaultData.count > 0 {
                        
                        
                        if self.page == 1 {
                            
                            self.tempResaultArray.removeAll()
                        }
                        
                        
                        for item in resaultData {
                            
                            let dict = item as! NSDictionary
                            
                            let resaultModel = YNEarlyToMyProgramModel(dict: dict)
                            
                            self.tempResaultArray.append(resaultModel)
                        }
                        
                        self.resaultArray = self.tempResaultArray
                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("没有数据了", toView: self.view)
                        
//                        self.resaultArray = [YNEarlyToMyProgramModel]()
                        
                    }
                    
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                self.tableView?.stopRefresh()
                
                if self.isFirstLoadData {
                    
                    progress!.hideUsingAnimation()
                    
                    self.isFirstLoadData = false
                }
                
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
    }
    
    
    

}
