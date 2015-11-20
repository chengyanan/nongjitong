//
//  YNScaleView.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/20.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNScaleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
    
    }

    func setInterface() {
    
        self.addSubview(backgroundView)
    }
    
    func setLayout() {
    
        //backgroundView
        Layout().addCenterXYConstraints(backgroundView, toView: self, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(backgroundView, toView: self, multiplier: 0.5, constant: 0)
        Layout().addHeightConstraint(backgroundView, toView: self, multiplier: 0.7, constant: 0)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundView: UIView = {
    
        let tempView = UIView()
        tempView.layer.cornerRadius = 10
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let titleLabel: UILabel = {
    
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textAlignment = .Center
        tempView.text = "10亩以下"
        return tempView
    }()
    
    
    
}
