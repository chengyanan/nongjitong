//
//  YNFinishInputView.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/3.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNFinishInputViewDelegate {

    func finishInputViewFinishButtonDidClick()
}

class YNFinishInputView: UIView {

    var delegate: YNFinishInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(finishButton)
        self.addSubview(insparatorView)
        finishButton.addTarget(self, action: "finishButtonDidClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        setLayout()
    }

    
    //MARK: event response
    func finishButtonDidClick() {
    
        delegate?.finishInputViewFinishButtonDidClick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLayout() {
    
        //finishButton
        Layout().addTopBottomConstraints(finishButton, toView: self, multiplier: 1, constant: 0)
        Layout().addRightConstraint(finishButton, toView: self, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(finishButton, toView: nil, multiplier: 0, constant: 60)
        
        //insparatorView
        Layout().addLeftTopRightConstraints(insparatorView, toView: self, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(insparatorView, toView: nil, multiplier: 0, constant: 0.45)
    }
    
    let insparatorView: UIView = {
    
        let tempView = UIView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return tempView
    }()
    
    let finishButton: UIButton = {
    
        let tempView = UIButton()
        tempView.setTitle("完成", forState: UIControlState.Normal)
        tempView.titleLabel?.font = UIFont.systemFontOfSize(14)
        tempView.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    }()
}
