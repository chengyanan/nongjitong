//
//  YNMYWriteWaringViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/5.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNMYWriteWaringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - private proporty
    
    var tableView: UITableView = {
        
        let tempView = UITableView()
        
        return tempView
        
    }()
    
    var isShowLoadMore = true
    var page: Int = 1
    var pagecount: Int = 20
    
    var tempResaultArray = [YNEarlyToMyProgramModel]()
    
    var resaultArray: Array<YNEarlyToMyProgramModel>? {
        
        didSet {
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        self.tableView.frame = self.view.bounds
        
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.whiteColor()
            
        self.title = "我写的预警方案"
        
        search()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        
    }

    
    func search() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Warning",
            "a": "getToOther",
            "user_id": kUser_ID() as? String,
            "page": String(page),
            "page_size": "\(pagecount)"
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
                        
                        if resaultData.count < 20 {
                            
                            //显示加载更多
                            self.isShowLoadMore = false
                        } else {
                            
                            //不显示加载更多
                            self.isShowLoadMore = true
                        }
                        
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
                        YNProgressHUD().showText("没有数据", toView: self.view)
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
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tempArray = self.resaultArray {
            
            if self.isShowLoadMore {
                
                return tempArray.count + 1
                
            } else {
                
                return tempArray.count
            }
            
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == self.resaultArray?.count {
            
            return 50
        }
        
        return self.resaultArray![indexPath.row].summaryHeight!
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.resaultArray?.count {
            
            let identify: String = "Cell_Resault_LoadMore_code"
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = YNResaultLoadModeCell(style: .Default, reuseIdentifier: identify)
                
            }
            
            return cell!
            
        }
        
        let tempmodel = self.resaultArray![indexPath.row]
        
        if tempmodel.photos!.count > 0 {
        
            let identify: String = "Cell_Search_Resault_WithImage"
            
            var cell: YNSearchSolutionWithImageCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionWithImageCell
            
            if cell == nil {
                
                cell = YNSearchSolutionWithImageCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                
            }
            
            cell?.earlyToMyProgramModel = tempmodel
            
            return cell!
            
            
        }
        
        let identify: String = "Cell_Search_Resault_code"
        var cell: YNSearchSolutionCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionCell
        
        if cell == nil {
            
            cell = YNSearchSolutionCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            
        }
        
        cell?.earlyToMyProgramModel = tempmodel
        
        return cell!
        
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == self.resaultArray?.count {
            
            loadMore()
            
        } else {
            
            // 预警详情
            let vc = MYWaringDetailViewController()
            vc.resaultModel = self.resaultArray![indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func loadMore() {
        
        self.page++
        self.search()
    }
    
    
    
}
