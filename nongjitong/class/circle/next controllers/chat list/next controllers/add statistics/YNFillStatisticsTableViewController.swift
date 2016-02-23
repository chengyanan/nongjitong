//
//  YNFillStatisticsTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/23.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNFillStatisticsTableViewControllerDelegate {

    func fillStatisticsTableViewControllerSuccess()
}

class YNFillStatisticsTableViewController: UITableViewController, YNFillNumberTableViewCellDelegate {

    
    var delegate: YNFillStatisticsTableViewControllerDelegate?
    
    var model: YNThreadModel?
    
    var voteDetailsModel: YNVoteDetailsModel?
    
    
    //MARK: life cycle
    init(model: YNThreadModel, detailModel: YNVoteDetailsModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
        
        self.voteDetailsModel = detailModel
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "填写统计"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .Plain, target: self, action: "doneButtonClick")

    }
    
    
    //MARK: event response
    func doneButtonClick() {
    
        var items = ""
        var values = ""
        
        for var i = 0; i < self.voteDetailsModel!.items.count; i++ {
        
            let item = self.voteDetailsModel!.items[i]
            
            if item.value != "0" {
            
                
                if i == self.voteDetailsModel!.items.count - 1 {
                    
                    
                    items += item.id!
                    values += item.value!
                    
                } else {
                
                    items += item.id! + "|"
                    values += item.value! + "|"
                }
                
                
            }
            
        }
        
        
        if items != "" {
            
            //有填写，上传数据
            sendDataToserver(items, values: values)
            
        } else {
        
            YNProgressHUD().showText("至少填写一项", toView: UIApplication.sharedApplication().keyWindow!)
        }
        
        
        
    }
    
    //MARK: uitableView dataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            //投票选项
            
            if let _ = self.voteDetailsModel {
                
                return self.voteDetailsModel!.items.count
                
            } else {
                
                return 0
            }
            
            
        }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            return 44
            
        }
        
        return self.model!.height!
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "CELL_Question"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNThreadListTableViewCell
            
            if cell == nil {
                
                cell = YNThreadListTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            
            cell?.model = self.model
            
            return cell!
            
        }
        
        let identify = "CELL_fill_item"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNFillNumberTableViewCell
        
        
        
        if cell == nil {
            
            cell = YNFillNumberTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        
        
        cell?.model = self.voteDetailsModel?.items[indexPath.row]
        
        cell?.delegate = self
        
        return cell!
        
        
    }
    
    //MARK: tableView delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.view.endEditing(true)
    }
    
    //YNFillNumberTableViewCellDelegate
    func fillNumberTableViewCell(cell: YNFillNumberTableViewCell) {
        
        if cell.textFilled.text != "" {
        
            //有数量处理
            self.voteDetailsModel?.items[cell.model!.index!].value = cell.textFilled.text
            
        }
        
        
    }
    
    
    //MARK: uploadData
    func sendDataToserver(items: String, values: String) {
        
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupCount",
            "a": "userVote",
            "vote_id": self.voteDetailsModel?.id,
            "user_id": userId,
            "values": values,
            "items": items
            
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        
                        YNProgressHUD().showText("提交成功", toView: self.view)
                        
                        self.delegate?.fillStatisticsTableViewControllerSuccess()
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            
                            //退出控制器
                            self.navigationController?.popViewControllerAnimated(true)
                            
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
    
    
    
    
    
    
}
