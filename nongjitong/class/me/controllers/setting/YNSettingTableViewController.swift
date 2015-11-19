//
//  YNSettingTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/12.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNSettingTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
        
            if indexPath.row == 0 {
            
                //退出登录
                Tools().removeValueForKey(kUserID)
                
                YNExchangeRootController().showSign()
                
            }
        }
    }
}
