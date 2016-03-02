//
//  YNDescoverButton.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/2.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDescoverButton: UIButton {

    
    override func layoutSubviews() {
       
        super.layoutSubviews()
        
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        Layout().addTopConstraint(self.imageView!, toView: self, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(self.imageView!, toView: self, multiplier: 1, constant: 0)
        Layout().addRightConstraint(self.imageView!, toView: self, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(self.imageView!, toView: self, multiplier: 0.7, constant: 0)
        
        Layout().addLeftConstraint(self.titleLabel!, toView: self, multiplier: 1, constant: 10)
        Layout().addRightConstraint(self.titleLabel!, toView: self, multiplier: 1, constant: -10)
        Layout().addTopToBottomConstraint(self.titleLabel!, toView: self.imageView!, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(self.titleLabel!, toView: self, multiplier: 1, constant: 0)
        
        
        
    }
    
    
}
