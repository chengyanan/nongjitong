//
//  YNEarlyWaringViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//预警

import UIKit

class YNEarlyWaringViewController: UIViewController {

    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    func setInterface() {
        
//        self.view.addSubview(segmentController)
    }
    
    func setLayout() {
        
        Layout().addTopConstraint(segmentController, toView: self.view, multiplier: 1, constant: 64)
        Layout().addCenterXConstraint(segmentController, toView: self.view, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(segmentController, toView: self.view, multiplier: 0.5, constant: 0)
        
    }
    
    //MARK: event response
    @IBAction func leftbarButtonClick(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    //MARK: UI components
    
    
    let segmentController: UISegmentedControl = {
    
        let tempView = UISegmentedControl(items: ["给我的方案", "写方案给别人"])
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.selectedSegmentIndex = 0
//        tempView.setTitle("给我的方案", forSegmentAtIndex: 0)
//        tempView.setTitle("写方案给别人", forSegmentAtIndex: 1)
        return tempView
        
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
