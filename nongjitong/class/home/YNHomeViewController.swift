//
//  YNHomeViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "首页"
        
        // Do any additional setup after loading the view.
    }

    
   //MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        
            return 1
        }
        
        return 7
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let identify: String = "Cell_SearchAndAnswer"
            var cell: YNSearchAndQuestionCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchAndQuestionCell
            
            if cell == nil {
                
                cell = YNSearchAndQuestionCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                
            }
            
            
            return cell!
        
        }
        
        let identify: String = "CELL_RestaurantName"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!


    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return 144
        }
        
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
            return 1
        }
        
        return 36
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if section == 1 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell_NewQuestionHeader")

            return cell
        }
        
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
