//
//  YNCircleViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/27.
//  Copyright © 2016年 农盟. All rights reserved.
//圈子功能

import UIKit

class YNCircleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNCircleTableViewCellDelegate {

    var page = 1
    var page_size = 20
    
    var dataArray = [YNCircleModel]()
    
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
    
    let tableView: UITableView = {
    
        let tempView = UITableView(frame: CGRectZero, style: .Plain)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        return tempView
        
    }()
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "合作社"
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "addNewSubscription"), style: .Plain, target: self, action: "addCircle")
        navigationItem.rightBarButtonItem = rightItem
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        
        loaddata()
        
        tableView.addFooterRefreshWithActionHandler { () -> Void in
            
            self.loadMore()
        }
        
        
        
        
        
    }
    
    func loadMore() {
    
        self.page++
        
        self.loaddata()
    }
    
    //MARK: event response
    func addCircle() {
    
        let vc = YNAddCircleViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return YNCircleTableViewCell.constantHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "Cell_circle"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNCircleTableViewCell
        
        if cell == nil {
        
            cell = YNCircleTableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.model = self.dataArray[indexPath.row]
        cell?.delegate = self
        
        return cell!
        
    }
    
    //MARK: tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let userid = kUser_ID() as? String
        
        if let _ = userid {
        
            //已登陆判断是否加入了该圈子
            self.isMemberships(self.dataArray[indexPath.row])
            
        } else {
        
            //没有登录，直接跳到登录界面
            let signInVc = YNSignInViewController()
            
            let navVc = UINavigationController(rootViewController: signInVc)
            
            self.presentViewController(navVc, animated: true, completion: { () -> Void in
                
            })
            
        }
        
        
        
    }
    
    //MARK: YNCircleTableViewCellDelegate
    func circleTableViewCellDontLoginin(cell: YNCircleTableViewCell) {
        
        //没有登录，直接跳到登录界面
        let signInVc = YNSignInViewController()
        
        let navVc = UINavigationController(rootViewController: signInVc)
        
        self.presentViewController(navVc, animated: true, completion: { () -> Void in
            
        })
        
    }
    
    func circleTableViewCellIsMembership(cell: YNCircleTableViewCell) {
        
        self.isMemberships(cell.model!)
    }
    
    func circleTableViewCellGotoReasonPage(cell: YNCircleTableViewCell) {
        
        let userId = kUser_ID() as? String
        
        if userId == cell.model?.user_id {
        
            YNProgressHUD().showText("不可以申请自己建的圈子", toView: self.view)
            
        } else {
        
            //进入申请理由界面
            let vc = YNWriteReasonViewController()
            vc.model = cell.model
            
            let nav = UINavigationController(rootViewController: vc)
            
            self.presentViewController(nav, animated: true) { () -> Void in
                
            }
            
        }
        
       
        
    }
    
    //MARK:判断用户是否是该群成员
    func isMemberships(model: YNCircleModel) {
        
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupUser",
            "a": "isInGroup",
            "group_id": model.id,
            "user_id": userId,
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let data = json["data"] as? Int
                        
//                        print(data)
                        
                        if data == 0 {
                        
                            //不是该群成员，跳申请页面
                            
                            let userId = kUser_ID() as? String
                            
                            if userId == model.user_id {
                                
                                YNProgressHUD().showText("不可以申请自己建的圈子", toView: self.view)
                                
                            } else {
                                
                                //进入申请理由界面
                                let vc = YNWriteReasonViewController()
                                vc.model = model
                                
                                let nav = UINavigationController(rootViewController: vc)
                                
                                self.presentViewController(nav, animated: true) { () -> Void in
                                    
                                }
                                
                            }
                            
                        } else if data == 1 {
                        
                            //是该群成员，可以进入详细页面
                            let vc = YNCircleDetailsViewController()
                            vc.model = model
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        
                        
                    } else if status == 0 {
                        
                        
                        
                        
//                        
//                        if let msg = json["msg"] as? String {
//                            
//                            
//                            YNProgressHUD().showText(msg, toView: self.view)
//                            
//                            
//                        }
                        
                        
                    }
                    
                }
                
            } catch {
                
                
                YNProgressHUD().showText("请求失败", toView: self.view)
            }
            
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("数据上传失败", toView: self.view)
        }
        
        
        
    }
    
    //MARK: load data
    func loaddata() {
    
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Group",
            "a": "getList",
            "page": "\(page)",
            "page_size": "\(page_size)"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
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
                        
                        
                            let model = YNCircleModel(dict: item as! NSDictionary)
                            
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
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
}
