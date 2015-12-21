//
//  YNQuestionAnswerTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/18.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionAnswerTableViewCell: UITableViewCell {
    

    var isFirstLayout = true
    
    var answeModel: YNAnswerModel? {
    
        didSet {
        
            
            
            self.textLabel?.text = answeModel?.content
            self.avatorImage.getImageWithURL(answeModel!.avatar!, contentMode: UIViewContentMode.ScaleToFill)
            self.nickName.text = answeModel?.user_name
            self.postTime.text = answeModel?.add_time
            
            if answeModel!.isQuestionOwner! {
            
                acceptAnswer.hidden = false
                
            } else {
            
                acceptAnswer.hidden = true
            }
            
            setLayout()
            
//            setNeedsLayout()
            
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setInterface()
        
        questionContent.numberOfLines = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
    
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        self.contentView.addSubview(questionContent)
        self.contentView.addSubview(acceptAnswer)
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    
////        setLayout()
//        
//    }
    
    func setLayout() {
        
        if let _  = answeModel {
        
            //avatorImage
            let avatorImageX = answeModel!.marginTopBottomLeftOrRight
            let avatorImageY = answeModel!.marginTopBottomLeftOrRight
            avatorImage.frame = CGRectMake(avatorImageX, avatorImageY, answeModel!.avatarWidthHeight, answeModel!.avatarWidthHeight)
            avatorImage.layer.cornerRadius = answeModel!.avatarWidthHeight * 0.5
//            print("avatorImage.frame = \(avatorImage.frame)")
            
//
//            Layout().addTopConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: answeModel!.marginTopBottomLeftOrRight)
//            Layout().addLeftConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: answeModel!.marginTopBottomLeftOrRight)
//            Layout().addHeightConstraint(avatorImage, toView: nil, multiplier: 0, constant: answeModel!.avatarWidthHeight)
//            Layout().addWidthConstraint(avatorImage, toView: nil, multiplier: 0, constant: answeModel!.avatarWidthHeight)
            
            //nickName
            let nickNameX = CGRectGetMaxX(avatorImage.frame) + 3
            let nickNameY = avatorImageY
            nickName.frame = CGRectMake(nickNameX, nickNameY, 180, 24)
//            print("nickName.frame = \(nickName.frame)")
//            Layout().addTopConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 0)
//            Layout().addLeftToRightConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 5)
//            Layout().addRightConstraint(nickName, toView: self.contentView, multiplier: 1, constant: -answeModel!.marginTopBottomLeftOrRight)
//            Layout().addHeightConstraint(nickName, toView: nil, multiplier: 0, constant: 24)
            
            //questionContent
            let questionContentX = avatorImageX
            let questionContentY = CGRectGetMaxY(avatorImage.frame) + answeModel!.marginTopBottomLeftOrRight
            let questionContentWidth = kScreenWidth - answeModel!.marginTopBottomLeftOrRight * 2
            let questionContentHeight = answeModel!.contentRealSize.height
            questionContent.frame = CGRectMake(questionContentX, questionContentY, questionContentWidth, questionContentHeight)
            
            
//            print("questionContent.frame = \(questionContent.frame)")
            
//            Layout().addLeftConstraint(questionContent, toView: avatorImage, multiplier: 1, constant: 0)
//            Layout().addRightConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: -answeModel!.marginTopBottomLeftOrRight)
//            Layout().addTopToBottomConstraint(questionContent, toView: avatorImage, multiplier: 1, constant: answeModel!.marginTopBottomLeftOrRight)
            
            //postTime
            let postTimeX = avatorImageX
            let postTimeY = CGRectGetMaxY(questionContent.frame) + answeModel!.marginTopBottomLeftOrRight
            postTime.frame = CGRectMake(postTimeX, postTimeY, 160, 30)
//            print("postTime.frame = \(postTime.frame)")
//            Layout().addLeftConstraint(postTime, toView: questionContent, multiplier: 1, constant: 0)
//            Layout().addTopToBottomConstraint(postTime, toView: questionContent, multiplier: 1, constant: 20)
////            Layout().addBottomConstraint(postTime, toView: self.contentView, multiplier: 1, constant: 0)
//            Layout().addHeightConstraint(postTime, toView: nil, multiplier: 1, constant: 30)
//            Layout().addWidthConstraint(postTime, toView: nil, multiplier: 0, constant: 160)
            
            //acceptAnswer
            let acceptAnswerX = kScreenWidth - answeModel!.marginTopBottomLeftOrRight - 50
            let acceptAnswerY = postTimeY
            acceptAnswer.frame = CGRectMake(acceptAnswerX, acceptAnswerY, 50, 30)
//            print("acceptAnswer.frame = \(acceptAnswer.frame)")
//            Layout().addTopConstraint(acceptAnswer, toView: postTime, multiplier: 1, constant: 0)
//            Layout().addBottomConstraint(acceptAnswer, toView: postTime, multiplier: 1, constant: 0)
//            Layout().addRightConstraint(acceptAnswer, toView: self.contentView, multiplier: 1, constant: -answeModel!.marginTopBottomLeftOrRight)
//            Layout().addWidthConstraint(acceptAnswer, toView: nil, multiplier: 0, constant:50)
            
        } else {
        
            //没有数据，不设置布局
        }
    

    }
    
    let avatorImage: UIImageView = {
        
        //头像
        let tempView = UIImageView()
//        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.clipsToBounds = true
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let nickName: UILabel = {
        
        //昵称
        let tempView = UILabel()
        tempView.font = UIFont.boldSystemFontOfSize(17)
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let postTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
//                tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let questionContent: UILabel = {
        
        let tempView = UILabel()
        tempView.numberOfLines = 0
        tempView.font = UIFont.systemFontOfSize(15)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tempView.sizeToFit()
        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let acceptAnswer: UIButton = {
    
        let tempView = UIButton()
        tempView.setTitle("采纳", forState: .Normal)
        tempView.setTitleColor(UIColor.blackColor(), forState: .Normal)
        tempView.layer.cornerRadius = 6
        tempView.clipsToBounds = true
        tempView.layer.borderWidth = 1
        tempView.layer.borderColor = UIColor.blueColor().CGColor
        tempView.titleLabel?.font = UIFont.systemFontOfSize(13)
//                tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    
    
}
