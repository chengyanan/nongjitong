//
//  YNDocDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var searchresault: YNSearchResaultModel? {
        
        didSet {
            
            self.title = searchresault?.title
            loadDetail()
        }
        
    }
    
    var serachResaultDetail: YNSearchResaultDetailModel? {
        
        didSet {
            
            //TODO: 刷新tableView
            self.setTableView()
            
        }
    }
    
    let tableView: UITableView = {
    
        let tempView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        
        return tempView
        
    }()
    
    let headerView: YNDocDetailListHeaderView = {
    
        let tempView = YNDocDetailListHeaderView()
        tempView.frame = CGRectMake(0, 0, kScreenWidth, 44)
        return tempView
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.whiteColor()
                
    }
    
    func setTableView() {
    
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)
    
        self.view.addSubview(tableView)
        
    }
    
    //MARK: private method
    func loadDetail() {
        
        let params = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Search",
            "a": "doc",
            "id": self.searchresault?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            //            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let dict = json["data"] as! NSDictionary
                    
                    let resaultDetail = YNSearchResaultDetailModel(dict: dict)
                    
                    self.serachResaultDetail = resaultDetail
                    
                    
                    
                } else if status == 0 {
                    
                    if let _ = json["msg"] as? String {
                        
                        YNProgressHUD().showText("没有文章详情", toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
    }
   
    //MARK:UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
        
            return 44
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 11
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return self.view.frame.size.height * 0.3
        
        } else if indexPath.section == 1 {
            
            return self.view.frame.size.height * 0.4
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
        
            return headerView
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            
            let identifier = "CELL_DocList_album"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNDocAlbumTableViewCell
            
            if cell == nil {
                
                cell = YNDocAlbumTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
//            cell!.serachResaultDetail = self.serachResaultDetail
            
            return cell!
            
            
        } else if indexPath.section == 1 {
        
            let identifier = "CELL_DocList_detail"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNWebContentTableViewCell
            
            if cell == nil {
                
                cell = YNWebContentTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            cell!.serachResaultDetail = self.serachResaultDetail
            
            return cell!
            
        }
        
        let identify = "text"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
        
    }
    
    
    
    
}
