//
//  YNDocDetailListHeaderView.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocDetailListHeaderView: UIView {

    
    let segmentControl: UISegmentedControl = {
    
        let tempView = UISegmentedControl(items: ["解决方案", "相关问题"])
        tempView.selectedSegmentIndex = 0
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    }()
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(segmentControl)
        
        segmentControl.addTarget(self, action: "segmentClick:", forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Layout().addTopConstraint(segmentControl, toView: self, multiplier: 1, constant: 6)
        Layout().addCenterXConstraint(segmentControl, toView: self, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(segmentControl, toView: self, multiplier: 0.5, constant: 0)
        Layout().addBottomConstraint(segmentControl, toView: self, multiplier: 1, constant: -8)
        
    }
    
    func segmentClick(sender: UISegmentedControl) {
    
        //TODO: 通知代理
        
    }
    
  
}
