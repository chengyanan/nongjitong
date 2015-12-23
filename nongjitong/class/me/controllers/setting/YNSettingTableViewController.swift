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
                Tools().removeValueForKey(kUserIsInformationFinish)
                Tools().removeValueForKey(kUserWatchListFinish)
                
//                YNExchangeRootController().showSign()
                
                //没有登录，直接跳到登录界面
                let signInVc = YNSignInViewController()
                
                let navVc = UINavigationController(rootViewController: signInVc)
                
                self.presentViewController(navVc, animated: true, completion: { () -> Void in
                    
                })
                
                
            }
        }
    }
}
