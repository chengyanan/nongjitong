//
//  YNQuestionTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/18.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionTableViewCell: UITableViewCell {
    
    let leftRightMargin: CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setInterface()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
    
        //avatorImage
        Layout().addTopConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: leftRightMargin)
        Layout().addLeftConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: leftRightMargin)
        Layout().addHeightConstraint(avatorImage, toView: nil, multiplier: 0, constant: 44)
        Layout().addWidthConstraint(avatorImage, toView: nil, multiplier: 0, constant: 44)
        
        //nickName
        Layout().addTopConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 5)
        Layout().addRightConstraint(nickName, toView: self.contentView, multiplier: 1, constant: -leftRightMargin)
        Layout().addHeightConstraint(nickName, toView: nil, multiplier: 0, constant: 24)
        
        //postTime
        Layout().addLeftConstraint(postTime, toView: nickName, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(postTime, toView: nickName, multiplier: 1, constant: 2)
        Layout().addBottomConstraint(postTime, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(postTime, toView: nil, multiplier: 0, constant: 80)
        
        //location
        Layout().addTopConstraint(location, toView: postTime, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(location, toView: postTime, multiplier: 1, constant: 0)
        Layout().addRightConstraint(location, toView: self.contentView, multiplier: 1, constant: -leftRightMargin)
        Layout().addLeftToRightConstraint(location, toView: postTime, multiplier: 1, constant: 10)
        
        //questionContent
        Layout().addLeftConstraint(questionContent, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addRightConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: -leftRightMargin)
        Layout().addTopToBottomConstraint(questionContent, toView: avatorImage, multiplier: 1, constant: 10)
        Layout().addHeightConstraint(questionContent, toView: nil, multiplier: 0, constant: 60)
//        Layout().addBottomConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: 0)
        
        
        
    }
    
    func setInterface() {
    
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        self.contentView.addSubview(location)
        self.contentView.addSubview(questionContent)
    }
    

    let avatorImage: UIImageView = {
    
        //头像
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let nickName: UILabel = {
    
        //昵称
        let tempView = UILabel()
        tempView.text = "rose"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let postTime: UILabel = {
    
        //昵称
        let tempView = UILabel()
        tempView.text = "11-18"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let location: UIButton = {
    
        //地点
        let tempView = UIButton()
        tempView.setTitle("河南省, 郑州市, 金水区", forState: .Normal)
        tempView.setImage(UIImage(named: "home_page_location_image"), forState: .Normal)
        tempView.backgroundColor = UIColor.redColor()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let questionContent: UILabel = {
        
        //问题内容
        let tempView = UILabel()
        tempView.text = "怎么种花生"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
}
