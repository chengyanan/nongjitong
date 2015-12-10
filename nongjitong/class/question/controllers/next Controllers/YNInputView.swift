//
//  YNInputView.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/9.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNInputViewDelegate {
    
    func inputViewFinishButtonDidClick()
    func inputViewTextViewDidChange(text: String)
}


class YNInputView: UIView, UITextViewDelegate {

    var delegate: YNInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kRGBA(231, g: 231, b: 231, a: 1)
        
        self.addSubview(finishButton)
        self.addSubview(insparatorView)
        self.addSubview(textView)
        
        textView.delegate = self
        
        finishButton.addTarget(self, action: "finishButtonDidClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        setLayout()
    }
    
    
    //MARK: event response
    func finishButtonDidClick() {
        
        delegate?.inputViewFinishButtonDidClick()
        
        self.textView.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLayout() {
        
        //finishButton
        Layout().addTopConstraint(finishButton, toView: self, multiplier: 1, constant: 6)
        Layout().addBottomConstraint(finishButton, toView: self, multiplier: 1, constant: -6)
        Layout().addRightConstraint(finishButton, toView: self, multiplier: 1, constant: -8)
        Layout().addWidthConstraint(finishButton, toView: nil, multiplier: 0, constant: 44)
        
        //insparatorView
        Layout().addLeftTopRightConstraints(insparatorView, toView: self, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(insparatorView, toView: nil, multiplier: 0, constant: 0.35)
        
        //textView
        Layout().addTopToBottomConstraint(textView, toView: insparatorView, multiplier: 1, constant: 5)
        Layout().addLeftConstraint(textView, toView: self, multiplier: 1, constant: 8)
        Layout().addRightToLeftConstraint(textView, toView: finishButton, multiplier: 1, constant: -5)
        Layout().addBottomConstraint(textView, toView: self, multiplier: 1, constant: -5)
    }
    
    let insparatorView: UIView = {
        
        let tempView = UIView()
//        tempView.hidden = true
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = kRGBA(200, g: 200, b: 200, a: 1)
        return tempView
    }()
    
    let finishButton: UIButton = {
        
        let tempView = UIButton()
        tempView.setTitle("发送", forState: UIControlState.Normal)
        tempView.titleLabel?.font = UIFont.systemFontOfSize(14)
        tempView.layer.cornerRadius = 3
        tempView.clipsToBounds = true
        tempView.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        tempView.backgroundColor = kRGBA(46, g: 163, b: 70, a: 1)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    }()
    
    let textView: YNTextView = {
    
        let tempView = YNTextView()
        tempView.layer.cornerRadius = 3
        tempView.layer.borderWidth = 1
        tempView.layer.borderColor = kRGBA(200, g: 200, b: 200, a: 1).CGColor
        tempView.clipsToBounds = true
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    
    //MARK: UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        
        self.delegate?.inputViewTextViewDidChange(textView.text)
        
    }
    
}
