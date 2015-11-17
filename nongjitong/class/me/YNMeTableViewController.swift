//
//  YNMeTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//我

import UIKit

class YNMeTableViewController: UITableViewController {

    //MARK: - tableViewDataSource
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 16
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    
    //MARK: - tableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 2 {
        
            let vc = YNMyWatchListViewController()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "Segue_Informatiom" {
//            
//            let destinationVc = segue.destinationViewController as! YNPersionalSettingTableViewController
//            
//            
//        }
//        
//        
//    }

   
    
}
