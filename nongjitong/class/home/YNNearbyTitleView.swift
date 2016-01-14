//
//  YNNearbyTitleView.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/21.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import UIKit

class YNNearbyTitleView: UIView {

    let kIndicatorWidth: CGFloat = 20
    
    var timer: NSTimer?
    var timeInterval: Int = 60
    
    lazy var indicator: UIActivityIndicatorView = {
        
        var tempIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        tempIndicator.startAnimating()
        return tempIndicator
        
        }()
    lazy var titleLabel: UILabel = {
        var tempLabel = UILabel()
//        tempLabel.textColor = kStyleColor
        tempLabel.textAlignment = NSTextAlignment.Center
        tempLabel.text = "农技通"
        
//        tempLabel.sizeToFit()
        
        return tempLabel
        }()
    
    
    var indicatorX: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        titleLabel.frame = self.bounds
        
        self.timer = NSTimer(timeInterval: 1, target: self, selector: "addOneSecond", userInfo: nil, repeats: true)
         NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        
    }

    
    func addOneSecond() {
        
        self.timeInterval -= 1
        
        //        print(self.timeInterval)
        if self.timeInterval > 0 {
            
            
        } else {
            
            self.end()
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateIndicatorX() {
        
        let selfWidth: CGFloat = frame.size.width
        let labelWidth: CGFloat = titleLabel.frame.size.width
        let indicatorWidth: CGFloat = indicator.bounds.size.width
        let plus = selfWidth - labelWidth - indicatorWidth
        indicatorX = plus/2

    }
    
    func start() {
        
        self.timer?.fire()
        
        self.titleLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(indicator)
        
        self.bringSubviewToFront(self.titleLabel)
        
        self.titleLabel.text = "加载中..."
        self.titleLabel.sizeToFit()
        
        calculateIndicatorX()
        
        if let _ = self.indicatorX {
       
            self.indicator.frame = CGRectMake(self.indicatorX!, 0, kIndicatorWidth, 44)
            
            let titileX = kIndicatorWidth + self.indicatorX!
            
            self.titleLabel.frame = CGRectMake(titileX, 0, self.frame.size.width - kIndicatorWidth, 44)
            
        }else {
       
            print("初始化位置不对", terminator: "")
        }
    
    }
    
    func end() {
        
        self.timer?.invalidate()
        
        self.indicator.removeFromSuperview()
        self.titleLabel.text = "农技通"
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.frame = self.bounds
        
//        UIView.animateWithDuration(1, animations: { () -> Void in
//        
//            
//            
//        }) { (finish) -> Void in
//            
//            
//            
//        }
        
    }
}
