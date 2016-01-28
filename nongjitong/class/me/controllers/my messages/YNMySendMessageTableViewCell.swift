//
//  YNMySendMessageTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNMySendMessageTableViewCell: UITableViewCell {
    
    var model: YNMessageModel? {
    
        didSet {
        
            titleLabel.text = model?.content!
            
            if model?.status == 0 {
            
                stateLabel.text = "待处理"
                
            } else if model?.status == 1 {
            
                stateLabel.text = "通过"
                
            } else if model?.status == 1 {
                
                stateLabel.text = "拒绝"
                
            }
            
            
        }
        
    }

    let titleLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(15)
        return tempView
        
    }()
    
    let stateLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.textAlignment = .Right
        
        return tempView
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateLabel)
        
        //stateLabel
        Layout().addTopBottomConstraints(stateLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(stateLabel, toView: contentView, multiplier: 1, constant: -12)
        Layout().addWidthConstraint(stateLabel, toView: nil, multiplier: 0, constant: 80)
        
        //titleLabel
        Layout().addTopBottomConstraints(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 12)
        Layout().addRightToLeftConstraint(titleLabel, toView: stateLabel, multiplier: 1, constant: 10)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
