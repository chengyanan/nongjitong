//
//  YNProvinceTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNProvinceTableViewController: UITableViewController {
    
    var data = [YNBaseCityModel]()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "省份"
        self.tableView.tableFooterView = UIView()
        
        getdataFromServer()
    }
    
    //MARK: 获取数据
    func getdataFromServer() {
    
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpGetCityTool().getAreaChildsWithParentId("0", successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    for item in tempdata {
                    
                        let city = YNBaseCityModel(dict: item as! NSDictionary)
                        
                        self.data.append(city)
                    }
                    
                    //tableview加载数据
                    self.tableView.reloadData()
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
//                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
              
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
        }
        
    }
    
    //MARK: tableview datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let idetify = "cell_City"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(idetify)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: idetify)
        }
        
        cell?.textLabel?.text = data[indexPath.row].city_name
        
        return cell!
        
    }
    
    //MARK: tableview delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("Segue_City", sender: indexPath.row)
        
    }

    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Segue_City" {
        
            let vc = segue.destinationViewController as! YNCityTableViewController
            
            vc.province = data[sender as! Int]

        }
        
    }
    
}
