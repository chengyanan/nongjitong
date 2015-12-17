//
//  YNEarlyWaringViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//预警

import UIKit

class YNEarlyWaringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    func setInterface() {
        

    }
    
    func setLayout() {
        
        
    }
    
    //MARK: event response
    @IBAction func leftbarButtonClick(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_Waring"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    //MARK: UI components
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
