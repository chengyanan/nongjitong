//
//  YNCityTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNCityTableViewController: UITableViewController {
    
    var province: YNBaseCityModel? {
    
        didSet {
        
            self.getdataFromServer()
        }
    }
    var citymodel = [YNBaseCityModel]()
    
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
    
        let numberOfViewControllers = (self.navigationController?.viewControllers.count)! - 3
        
        let vc = self.navigationController?.viewControllers[numberOfViewControllers]
        
        if vc!.isKindOfClass(YNAddUserInformationTableViewController.self) {
        
            let addVc = vc as! YNAddUserInformationTableViewController
            addVc.cityName = city.city_name
            
        } else if vc!.isKindOfClass(YNPersionalSettingTableViewController.self) {
        
            let addVc = vc as! YNPersionalSettingTableViewController
            addVc.cityName = city.city_name
            
            //TODO: 上传到服务器
            sendCityDataToSever(basemodel)
        }
        
        self.navigationController?.popToViewController(vc!, animated: true)
        
        
    }
    
    //MARK: 上传地区
    func sendCityDataToSever(baseModel: YNBaseModel) {
    
        let dict = ["paraName": "area_id",
            "text": baseModel.id]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        YNHttpTool().updateUserInformationText(dict, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let msg = json["msg"] as! String
                    
                    //#warning: msg是更新成功 不是登陆成功
                    print("\n \(msg) \n")
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }, failureFul: { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
                
        })

    }
    
}
