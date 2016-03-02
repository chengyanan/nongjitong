//
//  YNDiscoverViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/2.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDiscoverViewController: UIViewController {

    @IBOutlet var newsButton: UIButton!
    
    @IBOutlet var circleButton: UIButton!
    
    @IBOutlet var warningButton: UIButton!
    
    @IBOutlet var expertButton: UIButton!
    
    @IBOutlet var brandButton: UIButton!
    
    @IBOutlet var nongmengButton: UIButton!
    
    @IBOutlet var otherLinksButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置圆角
        setInterface()
        
        //设置点击事件
        setEventResponse()
        
    }
    
    func setInterface() {
    
        self.newsButton.layer.cornerRadius = 8
        self.circleButton.layer.cornerRadius = 8
        self.warningButton.layer.cornerRadius = 8
        self.expertButton.layer.cornerRadius = 8
        self.brandButton.layer.cornerRadius = 8
        self.nongmengButton.layer.cornerRadius = 8
        self.otherLinksButton.layer.cornerRadius = 8
        
        self.newsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        self.circleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        self.warningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        self.expertButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        self.brandButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        self.nongmengButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        self.otherLinksButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        
        self.newsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.circleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.warningButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.expertButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.brandButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.nongmengButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.otherLinksButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.newsButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.circleButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.warningButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.expertButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.brandButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.nongmengButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.otherLinksButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        
    }
    
    func setEventResponse() {
    
        self.newsButton.addTarget(self, action: "newsButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.circleButton.addTarget(self, action: "circleButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.warningButton.addTarget(self, action: "warningButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.expertButton.addTarget(self, action: "expertButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.brandButton.addTarget(self, action: "brandButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.nongmengButton.addTarget(self, action: "nongmengButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.otherLinksButton.addTarget(self, action: "otherLinksButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    //MARK: event response
    func newsButtonClick() {
    
        
        
    }
    
    func circleButtonClick() {
    
        let vc = YNCircleViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func warningButtonClick() {
    
        let warningVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SB_EarlyWaring")
        
        self.navigationController?.pushViewController(warningVc, animated: true)
    }
    
    func expertButtonClick() {
    
        
    }
    
    func brandButtonClick() {
    
        
    }
    
    func nongmengButtonClick() {
    
        
    }
    
    func otherLinksButtonClick() {
    
        
    }
    
    
    @IBAction func leftBarButtonClick(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
        
    }
    
    
    
    
    
}
