//
//  YNSearchResaultSolutionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//解决方案

import UIKit

class YNSearchResaultSolutionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var searchresault: YNSearchResaultModel? {
        
        didSet {
            
            //MARK: 加载搜索结果
//            search()
        }
    }
    
    var delegate: YNSearchViewControllerDelegate?
    
    //MARK: - private proporty
    
    var tableView: UITableView = {
    
        let tempView = UITableView()
        
        return tempView
        
    }()
    
    var isShowLoadMore = true
    var page: Int = 1
    var pagecount: Int = 20
    
    var tempResaultArray = [YNSearchSolutionListModel]()
    
    var resaultArray: Array<YNSearchSolutionListModel>? {
        
        didSet {
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相关解决方案"
        
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        self.tableView.frame = self.view.bounds
        
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "addNewSubscription"), style: .Plain, target: self, action: "writeSolution")
        
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = self.searchresault {
        
            self.page = 1
            
            search()
        }
        
    }
    
    //MARK: event response
    func writeSolution() {
    
        let vc = YNAnswerQuestionViewController()
        vc.searchresault = self.searchresault
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func search() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "DocPrograms",
            "a": "getDocProgramsList",
            "doc_id": searchresault?.id,
            "page": String(page),
            "pagecount": "\(pagecount)"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
//            print("data - \(json)")
            
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
                            
                            let resaultModel = YNSearchSolutionListModel(dict: dict)
                            
                            self.tempResaultArray.append(resaultModel)
                        }
                        
                        self.resaultArray = self.tempResaultArray
                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("没有相关解决方案", toView: self.view)
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
        
        return self.resaultArray![indexPath.row].height!
        
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
        
        let identify: String = "Cell_Search_Resault_code"
        var cell: YNSearchSolutionCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionCell
        
        if cell == nil {
            
            cell = YNSearchSolutionCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            
        }
        
        cell?.solutionModel = self.resaultArray![indexPath.row]
        
        return cell!
        
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == self.resaultArray?.count {
            
            loadMore()
            
        } else {
            
            //TODO: 方案详情
            
            
        }
        
    }
    
    func loadMore() {
        
        self.page++
        self.search()
    }
    
    
}
