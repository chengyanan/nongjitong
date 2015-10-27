//
//  YNCityTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNCityTableViewControllerDelegate {

    func cityTableViewController(vc: YNCityTableViewController, province: YNBaseCityModel, city: YNBaseModel)
}

class YNCityTableViewController: UITableViewController {

    var province: YNBaseCityModel? {
    
        didSet {
        
            self.getdataFromServer()
        }
    }
    var citymodel = [YNBaseCityModel]()
    var delegate: YNCityTableViewControllerDelegate?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "城市"
    }
    
    //MARK: 获取数据
    func getdataFromServer() {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpGetCityTool().getAreaChildsWithParentId(self.province!.id, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    for item in tempdata {
                        
                        let city = YNBaseCityModel(dict: item as! NSDictionary)
                        
                        self.citymodel.append(city)
                    }
                    
                    //TableView加载数据
                    self.tableView.reloadData()
                    
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
    
    
    //MARK: tableview datasource 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return citymodel.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let idetify = "cell_City"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(idetify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: idetify)
        }
        
        cell?.textLabel?.text = citymodel[indexPath.row].city_name
        
        return cell!
        
    }
    
    
    //MARK: tableview delegate 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let city = self.citymodel[indexPath.row]
        let basemodel = YNBaseModel()
        basemodel.id = city.id
        basemodel.name = city.city_name
        
        //TODO: 上传到服务器
        
        self.delegate?.cityTableViewController(self, province: self.province!, city: basemodel)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
}
