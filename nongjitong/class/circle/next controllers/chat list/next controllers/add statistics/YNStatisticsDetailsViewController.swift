//
//  YNStatisticsDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/24.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNStatisticsDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var model: YNVoteItem?
    
    var dataArray = [YNStatisticsDetailsModel]()
    
    var tableView: UITableView?
    
    
    init(model: YNVoteItem) {
    
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "统计明细"
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView

        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
        
        //加载具体数据
        self.loadData()
    }
    
    //MARK: uitableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            return self.dataArray.count
            
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 2
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "CELL_Vote_Item"
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            cell?.selectionStyle = .None
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Value1, reuseIdentifier: identify)
            }
            
            cell?.textLabel?.text = model!.title
  
            cell?.detailTextLabel?.text = model!.value!
            
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13)
            
            return cell!
            
            
        }
        
        
        let identify = "CELL_statistics_Value"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNStatisticsDetailsTableViewCell
        
        cell?.selectionStyle = .None
        
        if cell == nil {
            
            cell = YNStatisticsDetailsTableViewCell(style: .Value1, reuseIdentifier: identify)
        }
        
        cell?.model = self.dataArray[indexPath.row]
        
        return cell!
    }
    
    
    
    //MARK: uploadData
    func loadData() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupCount",
            "a": "getUserVoteDetail",
            "item_id": model?.id,
            "user_id": kUser_ID() as? String,
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let temparray = json["data"] as? NSArray
                        
                        for item in temparray! {
                            
                            let tempModel = YNStatisticsDetailsModel(dict: item as! NSDictionary)
                            
                            self.dataArray.append(tempModel)
                            
                        }
                        
                        self.tableView?.reloadData()
                        
                        
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
