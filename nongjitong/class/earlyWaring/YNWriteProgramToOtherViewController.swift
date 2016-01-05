//
//  YNWriteProgramToOtherViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNWriteProgramToOtherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var model: YNEarlyToMyProgramModel? {
        
        didSet {
            
            self.tableView?.reloadData()
        }
    }
    
    
    var tableView: UITableView?
    
    //MARK: life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "给别人写预警"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        tableView?.reloadData()
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "\(model!.user_name!)的订阅"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 46
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.model {
            
            if section == 0 {
                
                return model!.subscribe.count
                
            } else {
                
                return 1
            }
            
        }
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "CELL_MyScrible"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            cell?.selectionStyle = .None
            
            let subscribeModel = self.model?.subscribe[indexPath.row]
            
            cell?.textLabel?.text = "\(subscribeModel!.class_name!)  \(subscribeModel!.city_name!)  \(subscribeModel!.range!)"
            
            return cell!
            
        }
        
        let idenfier = "CELL_ToMyProgram"
        var cell = tableView.dequeueReusableCellWithIdentifier(idenfier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: idenfier)
        }
        
        cell?.textLabel?.text = "给他写预警"
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
        
    }
    
    //MARK: tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
        
            let vc = YNAnswerQuestionViewController()
            vc.actionType = ActionType.WriteWarning
            vc.warningModel = self.model
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}
