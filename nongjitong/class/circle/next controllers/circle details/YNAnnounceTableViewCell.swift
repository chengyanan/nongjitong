//
//  YNAnnounceTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/30.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNAnnounceTableViewCell: UITableViewCell {
    
    var textStr: String? {
    
        didSet {
        
            titleLabel.text = textStr
        }
    }

    let titleLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(13)
        return tempView
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
        //titleLabel
        Layout().addTopConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 12)
        Layout().addRightConstraint(titleLabel, toView: contentView, multiplier: 1, constant: -12)
    
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
