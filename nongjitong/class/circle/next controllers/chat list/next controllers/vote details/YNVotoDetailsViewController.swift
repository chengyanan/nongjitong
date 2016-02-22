//
//  YNVotoDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/22.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNVotoDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //7 是投票 8是统计
    var type: String?
    
    var model: YNThreadModel?
    
    var voteDetailsModel: YNVoteDetailsModel?
    
    var tableView: UITableView?
    
    var voteButton: UIButton?
    
    init(type: String, model: YNThreadModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.type = type
        self.model = model
        
        switch type {
            
        case "7":
            self.title = "投票详情"
            break
        case "8":
            self.title = "统计详情"
            break
            
        default:
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setLayout()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        loadVoteDetails()
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "讨论", style: .Plain, target: self, action: "chatButtonClick")
    }
    
    func setLayout() {
    
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.hidden = true
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -44)
        
        //voteButton
        self.voteButton = UIButton()
        self.voteButton?.setTitle("立即投票", forState: UIControlState.Normal)
        self.voteButton?.setTitleColor(kRGBA(0, g: 144, b: 217, a: 1), forState: UIControlState.Normal)
        self.voteButton?.titleLabel?.font = UIFont.systemFontOfSize(15)
        
//        self.voteButton?.layer.borderColor = UIColor.grayColor().CGColor
//        self.voteButton?.layer.borderWidth = 0.5
        
        self.voteButton?.layer.cornerRadius = 3
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
        
        if let _ = self.voteDetailsModel {
        
            let vc = YNVoteViewController(model: self.model!, detailModel: self.voteDetailsModel!)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    
        
    }
    
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//    func chatButtonClick() {
//        
//        //进入讨论界面
//        let chatVc = YNThreadChatViewController(model: self.model!)
//        
//        self.navigationController?.pushViewController(chatVc, animated: true)
//    }
    
    
    
    //MARK: uitableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
        
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
            
            return "标题"
        }
        
        if section == 2 {
            
            return "描述"
        }
        
        if section == 3 {
        
            return "投票项"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return YNThreadMargin().topMargin*2 + YNThreadMargin().avatarHeight
            
        } else if indexPath.section == 1 {
            
            return model!.titleHeight!
            
        } else if indexPath.section == 3 {
            
            return 44
        }
        
        return model!.contentHeight!
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "CELL_Thread_Info"
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNThreadDetailsInfoTableViewCell
            
            if cell == nil {
                
                cell = YNThreadDetailsInfoTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            cell?.model = self.model
            
            return cell!
            
        } else if indexPath.section == 3 {
        
            let identify = "CELL_Vote_Item"
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            cell?.selectionStyle = .None
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Value1, reuseIdentifier: identify)
            }
            
            let item = self.voteDetailsModel?.items[indexPath.row]
            
            cell?.textLabel?.text = item!.title
            cell?.detailTextLabel?.text = item!.value! + "票"
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13)
            
            return cell!
            
        }
        
        
        let identify = "CELL_Thread_content"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        cell?.selectionStyle = .None
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        if indexPath.section == 1 {
            
            cell?.textLabel?.text = model?.title!
            
        } else if indexPath.section == 2 {
            
            cell?.textLabel?.text = model?.descript!
        }
        
        
        return cell!
        
        
    }
    
    
    //MARK: loaddata
    func loadVoteDetails() {
    
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupVote",
            "a": "getDetail",
            "vote_id": model?.id,
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
                        
                        let temp = json["data"] as! NSDictionary
                        
                        self.voteDetailsModel = YNVoteDetailsModel(dict: temp)
                        
                        self.tableView?.hidden = false
                        
                        
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
                
                self.tableView?.stopRefresh()
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    
}
