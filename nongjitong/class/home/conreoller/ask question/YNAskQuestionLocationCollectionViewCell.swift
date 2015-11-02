//
//  YNAskQuestionLocationCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAskQuestionLocationCollectionViewCell: UICollectionViewCell {


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(locationButton)
        
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
    
        Layout().addLeftConstraint(locationButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addTopBottomConstraints(locationButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(locationButton, toView: nil, multiplier: 0, constant: 100)
    }
    
    let locationButton: UIButton = {
    
        var tempView = UIButton()
        tempView.titleLabel?.font = UIFont.systemFontOfSize(15)
        tempView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tempView.setTitle("当前地址", forState: UIControlState.Normal)
        tempView.setImage(UIImage(named: "home_ask_question_location"), forState: UIControlState.Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    } ()
    
}
