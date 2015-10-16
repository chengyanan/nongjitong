//
//  YNCityTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNCityTableViewControllerDelegate {

    func cityTableViewController(vc: YNCityTableViewController, province: YNBaseModel, city: YNBaseModel)
}

class YNCityTableViewController: UITableViewController {

    var citymodel: YNCityModel = YNCityModel()
    var delegate: YNCityTableViewControllerDelegate?
    
    
    //MARK: tableview datasource 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return citymodel.array.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let idetify = "cell_City"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(idetify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: idetify)
        }
        
        cell?.textLabel?.text = citymodel.array[indexPath.row].name
        
        return cell!
        
    }
    
    
    //MARK: tableview delegate 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        
        let province = YNBaseModel()
        province.id = self.citymodel.id
        province.name = self.citymodel.name
        
        let city = self.citymodel.array[indexPath.row]
        
        self.delegate?.cityTableViewController(self, province: province, city: city)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
}
