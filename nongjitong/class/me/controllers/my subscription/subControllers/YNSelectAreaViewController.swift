//
//  YNSelectAreaViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNSelectAreaViewControllerDelegate {

    func selectAreaViewControllerDidSelectArea(model: YNBaseCityModel)
}


class YNSelectAreaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var delegate: YNSelectAreaViewControllerDelegate?
    
    var data = [YNBaseCityModel]()
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "地区"
        
        let model = YNBaseCityModel()
        model.id = "0"
        getdataFromServer(model)
        
        setInterface()
        setLayout()
    }

    
    
    func setInterface() {
    
        //tableView
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableFooterView = UIView()
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.showsVerticalScrollIndicator = false
        tempTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
    }
    
    func setLayout() {
    
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "Cell_select_data"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.text = data[indexPath.row].city_name
        
        return cell!
        
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        getdataFromServer(data[indexPath.row])
    }
    
    //MARK: 获取数据
    func getdataFromServer(model: YNBaseCityModel) {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpGetCityTool().getAreaChildsWithParentId(model.id, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            print(json)
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                    
                        self.data.removeAll()
                        
                        for item in tempdata {
                            
                            let city = YNBaseCityModel(dict: item as! NSDictionary)
                            
                            self.data.append(city)
                        }
                        
                        self.tableView?.reloadData()
                        self.tableView?.scrollsToTop = true
                        
                    } else {
                    
                        self.delegate?.selectAreaViewControllerDidSelectArea(model)
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
        }
        
        
    }

    
    
}
