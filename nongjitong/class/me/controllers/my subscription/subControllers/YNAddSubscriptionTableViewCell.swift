//
//  YNAddSubscriptionTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddSubscriptionTableViewCell: UITableViewCell {

    func setInterface() {
    
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(contentLabel)
    }
    
    func setLayout() {
    
        //nameLabel
        Layout().addTopConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(nameLabel, toView: nil, multiplier: 1, constant: 0)
        
        //contentLabel 
        Layout().addTopConstraint(contentLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(contentLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(contentLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(contentLabel, toView: nameLabel, multiplier: 1, constant: 20)
    }
    
    let nameLabel: UILabel =  {
        
        //种类名称
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let contentLabel: UILabel =  {
        //规模
        let tempView = UILabel()
        tempView.textAlignment = .Right
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
}
