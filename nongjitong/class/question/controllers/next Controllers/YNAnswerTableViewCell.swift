//
//  YNAnswerTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAnswerTableViewCell: UITableViewCell {
    
    var questionModel: YNAnswerModel? {
    
        didSet {
        
            if let _ = questionModel {
                
                //TODO: 设置头像 和文字
                self.contentButton.setTitle(questionModel?.description, forState: .Normal)
                
                if questionModel!.isQuestionOwner! {
                
                    self.contentButton.setBackgroundImage(resizeImage("bubble_left_blue"), forState: .Normal)
                    
                } else {
                
                     self.contentButton.setBackgroundImage(resizeImage("bubble_green"), forState: .Normal)
                }
                
                
            }
            
        }
    }
    
    func resizeImage(name: String) -> UIImage{
    
        let image = UIImage(named: name)
        
        let top =  image!.size.width * 0.5
        let left = image!.size.height * 0.5
        
        let newimage = image!.resizableImageWithCapInsets(UIEdgeInsets(top: top, left: left, bottom: top, right: left), resizingMode: .Stretch)
        
        return newimage
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
    
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(contentButton)
        
    }
    
    //头像
    let avatarImageView: UIImageView = {
    
        let tempView = UIImageView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.image = UIImage(named: "admin")
        tempView.contentMode = .ScaleToFill
        return tempView
        
    }()
    
    //文字
    let contentButton: UIButton = {
    
        let tempView = UIButton()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(15)
        tempView.titleLabel?.numberOfLines = 0
        tempView.setTitleColor(UIColor.blackColor(), forState: .Normal)
        tempView.backgroundColor = UIColor.clearColor()
        tempView.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        tempView.userInteractionEnabled = false
//        tempView.backgroundColor = UIColor.redColor()
        tempView.titleLabel?.textAlignment = .Center
        return tempView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //avatarImageView
        Layout().addTopConstraint(avatarImageView, toView: self.contentView, multiplier: 1, constant: 10)
        Layout().addWidthHeightConstraints(avatarImageView, toView: nil, multiplier: 1, constant: questionModel!.avatarWidthHeight)
        
        if self.questionModel!.isQuestionOwner! {
            
            //avatarImageView
            Layout().addLeftConstraint(avatarImageView, toView: self.contentView, multiplier: 1, constant: 10)
    
            //contentLabel
            Layout().addLeftToRightConstraint(contentButton, toView: avatarImageView, multiplier: 1, constant: questionModel!.margin)
           
            
        } else {
        
            //avatarImageView
            Layout().addRightConstraint(avatarImageView, toView: self.contentView, multiplier: 1, constant: -10)
            
            //contentLabel
            Layout().addRightToLeftConstraint(contentButton, toView: avatarImageView, multiplier: 1, constant: -questionModel!.margin)
        
        }
    
        Layout().addTopConstraint(contentButton, toView: avatarImageView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(contentButton, toView: nil, multiplier: 0, constant: questionModel!.contentSize.height)
        Layout().addWidthConstraint(contentButton, toView: nil, multiplier: 0, constant: questionModel!.contentSize.width)
    }
    
}
