//
//  YNProvinceTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit


protocol YNProvinceTableViewControllerDelegate {
    
    func provinceTableViewController(vc: YNProvinceTableViewController, province: YNBaseModel, city: YNBaseModel)
}

class YNProvinceTableViewController: UITableViewController, YNCityTableViewControllerDelegate {

    
    var data: Array<YNCityModel> = Array()
    var delegate: YNProvinceTableViewControllerDelegate?
    
    
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
        
        cell?.textLabel?.text = data[indexPath.row].name
        
        return cell!
        
    }
    
    //MARK: tableview delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        let vc = UIStoryboard().instantiateViewControllerWithIdentifier("SB_City") as! YNCityTableViewController
        vc.delegate = self
        vc.citymodel = data[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    //MARK: - YNCityTableViewControllerDelegate
    func cityTableViewController(vc: YNCityTableViewController, province: YNBaseModel, city: YNBaseModel) {
        
        self.delegate?.provinceTableViewController(self, province: province, city: city)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
