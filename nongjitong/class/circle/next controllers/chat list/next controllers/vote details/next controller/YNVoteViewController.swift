//
//  YNVoteViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/22.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNVoteViewControllerDelegate {

    func voteViewControllerSuccess()
    
}

class YNVoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNVoteItemTableViewCellDelegate  {

    var delegate: YNVoteViewControllerDelegate?
    
    var model: YNThreadModel?
    
    var voteDetailsModel: YNVoteDetailsModel?
    
    var tableView: UITableView?
    
    var voteButton: UIButton?
    
    
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
        
        self.title = "投票"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setLayout()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        
    }
    
    func setLayout() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -44)
        
        //voteButton
        self.voteButton = UIButton()
        self.voteButton?.setTitle("投票", forState: UIControlState.Normal)
        self.voteButton?.setTitleColor(kRGBA(0, g: 144, b: 217, a: 1), forState: UIControlState.Normal)
        self.voteButton?.titleLabel?.font = UIFont.systemFontOfSize(17)
        self.voteButton?.layer.borderColor = UIColor.grayColor().CGColor
        self.voteButton?.layer.borderWidth = 0.5
        self.voteButton?.layer.cornerRadius = 5
        self.voteButton?.clipsToBounds = true
        self.voteButton?.addTarget(self, action: "voteButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.voteButton?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.voteButton!)
        
        Layout().addTopToBottomConstraint(voteButton!, toView: tableView!, multiplier: 1, constant: 6)
        Layout().addLeftConstraint(voteButton!, toView: self.view, multiplier: 1, constant: 12)
        Layout().addBottomConstraint(voteButton!, toView: self.view, multiplier: 1, constant: -6)
        Layout().addRightConstraint(voteButton!, toView: self.view, multiplier: 1, constant: -12)
    }
    
    //MARK: event response
    
    func voteButtonClick() {
        
        var itemId: String?
        
        for item in self.voteDetailsModel!.items {
        
            if item.isSelected {
            
                itemId = item.id
                break
            }
            
        }
        
        if let _ = itemId {
        
            //选了投票项目
            
            loadVoteDetails(itemId!)
            
        } else {
        
            //没选投票项目
            YNProgressHUD().showText("请选择一个投票项目", toView: self.view)
            
        }
        
    }
    
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: uitableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "单选"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            return 44
            
        }
        
        return self.model!.height!
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "CELL_Question"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNThreadListTableViewCell
            
            if cell == nil {
                
                cell = YNThreadListTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            
            cell?.model = self.model
            
            return cell!
            
        }
        
        let identify = "CELL_Vote_selected_item"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNVoteItemTableViewCell
        
        cell?.selectionStyle = .None
        
        if cell == nil {
            
            cell = YNVoteItemTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.model = self.voteDetailsModel?.items[indexPath.row]
        
        cell?.delegate = self
        
        return cell!
        
        
    }
    
    //MARK: YNVoteItemTableViewCellDelegate
    func voteItemTableViewCellSelectButtonClick(cell: YNVoteItemTableViewCell) {
        
        
        if cell.model!.isSelected {
        
            for item in self.voteDetailsModel!.items {
                
                item.isSelected = false
            }
            
            self.voteDetailsModel?.items[cell.model!.index!].isSelected = true
            
        } else {
        
            self.voteDetailsModel?.items[cell.model!.index!].isSelected = false
            
        }
        
        self.tableView?.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
        
        
    }
    
    
    //MARK: loaddata
    func loadVoteDetails(itemId: String) {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupVote",
            "a": "userVote",
            "vote_id": model?.id,
            "user_id": kUser_ID() as? String,
            "item_id": itemId
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        YNProgressHUD().showText("投票成功", toView: self.view)
                        
                        //通知代理刷新控制器
                        self.delegate?.voteViewControllerSuccess()
                        
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
                
                self.tableView?.stopRefresh()
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    
    
}
