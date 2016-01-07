//
//  YNAskQuestionExplianCollectionCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/7.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNAskQuestionExplianCollectionCell: UICollectionViewCell {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(explainLabel)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
    
        Layout().addTopConstraint(explainLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(explainLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(explainLabel, toView: self.contentView, multiplier: 1, constant: 15)
        Layout().addRightConstraint(explainLabel, toView: self.contentView, multiplier: 1, constant: -15)
        
    }
    
    let explainLabel: UILabel = {
        
        var tempView = UILabel()
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.numberOfLines = 0
        tempView.userInteractionEnabled = false
        tempView.textColor = UIColor.lightGrayColor()
        tempView.textAlignment = NSTextAlignment.Left
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
}
