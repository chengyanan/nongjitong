//
//  YNEndTimeCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/22.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNEndTimeCollectionViewCell: UICollectionViewCell {

    static let identifier = "Cell_EndTime"
    
    let tipLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.text = "结束时间"
        
        tempView.textColor = UIColor(red: 112/255.0, green: 112/255.0, blue: 112/255.0, alpha: 1)
        
        tempView.font = UIFont.boldSystemFontOfSize(15)
        
        return tempView
        
    }()
    
    let endtimeLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.text = "结束时间"
        
        tempView.textColor = UIColor.blackColor()
        
        tempView.font = UIFont.boldSystemFontOfSize(15)
        
        return tempView
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tipLabel)
        contentView.addSubview(endtimeLabel)
        
        //tipLabel
        Layout().addTopBottomConstraints(tipLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tipLabel, toView: contentView, multiplier: 1, constant: 12)
        Layout().addWidthConstraint(tipLabel, toView: nil, multiplier: 0, constant: 60)
        
        //endtimeLabel
        Layout().addTopBottomConstraints(endtimeLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(endtimeLabel, toView: contentView, multiplier: 1, constant: -12)
        Layout().addWidthConstraint(endtimeLabel, toView: nil, multiplier: 1, constant: 100)
        
        
        self.backgroundColor = UIColor.whiteColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}
