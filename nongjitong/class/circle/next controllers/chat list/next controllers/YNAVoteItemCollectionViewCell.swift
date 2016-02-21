//
//  YNAVoteItemCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/21.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNAVoteItemCollectionViewCell: UICollectionViewCell {

    static let identify = "Cell_add_Vote"
    
    let addButton: UILabel = {
    
        let tempView = UILabel()

        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.text = "添加投票项"
        
        tempView.textColor = UIColor.blackColor()

        tempView.font = UIFont.boldSystemFontOfSize(15)
        
        return tempView
    
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.whiteColor()
        
        contentView.addSubview(addButton)
        
        Layout().addTopConstraint(addButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(addButton, toView: contentView, multiplier: 1, constant: 12)
        Layout().addBottomConstraint(addButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(addButton, toView: contentView, multiplier: 1, constant: -12)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
