//
//  YNAddSubscriptionTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddSubscriptionTableViewCell: UITableViewCell {
    
    var name = "" {
    
        didSet {
        
            self.nameLabel.text = name
        }
    }
    var content = "" {
    
        didSet {
            
            self.contentLabel.text = content
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .DisclosureIndicator
        
        setInterface()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInterface() {
    
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(contentLabel)
    }
    
    func setLayout() {
    
        //nameLabel
        Layout().addTopConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 12)
        Layout().addBottomConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(nameLabel, toView: nil, multiplier: 1, constant: 80)
        
        //contentLabel 
        Layout().addTopConstraint(contentLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(contentLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(contentLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(contentLabel, toView: nameLabel, multiplier: 1, constant: 20)
    }
    
    let nameLabel: UILabel =  {
        
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let contentLabel: UILabel =  {
        //内容
        let tempView = UILabel()
        tempView.textAlignment = .Right
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.textColor = UIColor.grayColor()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
}
