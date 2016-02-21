//
//  YNThreadDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/16.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNThreadDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var type: String?
    var model: YNThreadModel?
    
    var tableView: UITableView?
    
    init(type: String, model: YNThreadModel) {
    
        super.init(nibName: nil, bundle: nil)
        
        self.type = type
        self.model = model
        
        switch type {
            
        case "1":
            self.title = "通知详情"
            break
        case "2":
            self.title = "销售详情"
            break
        case "3":
            self.title = "采购详情"
            break
        case "4":
            self.title = "分成详情"
            break
        case "5":
            self.title = "台帐详情"
            break
        case "6":
            self.title = "意见详情"
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
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "讨论", style: .Plain, target: self, action: "chatButtonClick")
    }
    
    //MARK: event response
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func chatButtonClick() {
    
        //进入讨论界面
        let chatVc = YNThreadChatViewController(model: self.model!)
        
        self.navigationController?.pushViewController(chatVc, animated: true)
    }
    
    //MARK: uitableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return YNThreadMargin().topMargin*2 + YNThreadMargin().avatarHeight
            
        } else if indexPath.section == 1 {
        
            return model!.titleHeight!
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
    
    
    
}
