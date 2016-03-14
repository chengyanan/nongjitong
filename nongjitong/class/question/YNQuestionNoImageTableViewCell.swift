//
//  YNQuestionNoImageTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/14.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNQuestionNoImageTableViewCell: UITableViewCell {

    
    let marginModel = YNQuestionModelConstant()
    
    var model: YNQuestionModel? {
        
        didSet {
            
            self.nickName.text = model?.user_name
            self.postTime.text = model?.createTime
            self.questionContent.text = model?.descript
            self.location.setTitle(model?.address, forState: .Normal)
            self.catagoryButton.setTitle(model?.class_name, forState: .Normal)
            self.answerCountButton.setTitle(model?.answer_count, forState: .Normal)
            
            self.avatorImage.getImageWithURL(model!.avatar!, contentMode: UIViewContentMode.ScaleToFill)
            
        }
    }
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setInterface()
        setLayout()
        
        self.selectionStyle = .None
        self.avatorImage.layer.cornerRadius = marginModel.avatarHeight * 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLayout() {
        
        //avatorImage
        Layout().addTopConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: marginModel.topMargin)
        Layout().addLeftConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: marginModel.leftRightMargin)
        Layout().addHeightConstraint(avatorImage, toView: nil, multiplier: 0, constant: marginModel.avatarHeight)
        Layout().addWidthConstraint(avatorImage, toView: nil, multiplier: 0, constant: marginModel.avatarHeight)
        
        //nickName
        Layout().addTopConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 5)
        Layout().addRightConstraint(nickName, toView: self.contentView, multiplier: 1, constant: -marginModel.leftRightMargin)
        Layout().addHeightConstraint(nickName, toView: nil, multiplier: 0, constant: 18)
        
        //postTime
        Layout().addLeftConstraint(postTime, toView: nickName, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(postTime, toView: nickName, multiplier: 1, constant: 2)
        Layout().addBottomConstraint(postTime, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(postTime, toView: nil, multiplier: 0, constant: 80)
        
        //location
        Layout().addTopConstraint(location, toView: postTime, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(location, toView: postTime, multiplier: 1, constant: 0)
        Layout().addRightConstraint(location, toView: self.contentView, multiplier: 1, constant: -marginModel.leftRightMargin)
        Layout().addLeftToRightConstraint(location, toView: postTime, multiplier: 1, constant: 10)
        
        //questionContent
        Layout().addLeftConstraint(questionContent, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addRightConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: -marginModel.leftRightMargin)
        Layout().addTopToBottomConstraint(questionContent, toView: avatorImage, multiplier: 1, constant: 15)
        
        //answerCountButton
        Layout().addBottomConstraint(answerCountButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(answerCountButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(answerCountButton, toView: self.contentView, multiplier: 0.5, constant: 0)
        Layout().addHeightConstraint(answerCountButton, toView: nil, multiplier: 0, constant: marginModel.answerCountHeight)
        
        //catagoryButton
        Layout().addBottomConstraint(catagoryButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(catagoryButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(catagoryButton, toView: answerCountButton, multiplier: 1, constant: 0)
        Layout().addRightToLeftConstraint(catagoryButton, toView: answerCountButton, multiplier: 1, constant: 0)
    }
    
    func setInterface() {
        
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        self.contentView.addSubview(location)
        self.contentView.addSubview(questionContent)
        self.contentView.addSubview(catagoryButton)
        self.contentView.addSubview(answerCountButton)
    }
    
    //MARK: interface UI
    let avatorImage: UIImageView = {
        
        //头像
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        tempView.layer.drawsAsynchronously = true
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let nickName: UILabel = {
        
        //昵称
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.boldSystemFontOfSize(13)
        tempView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        tempView.layer.drawsAsynchronously = true
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let postTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.layer.drawsAsynchronously = true
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let location: UIButton = {
        
        //地点
        let tempView = UIButton()

        tempView.setImage(UIImage(named: "home_page_location_image"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.layer.drawsAsynchronously = true
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        tempView.userInteractionEnabled = false
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let questionContent: UILabel = {
        
        //问题内容
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.layer.drawsAsynchronously = true
        tempView.numberOfLines = 3
        tempView.font = UIFont.systemFontOfSize(15)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tempView.backgroundColor = UIColor.whiteColor()
        
        return tempView
    }()
    
    let catagoryButton: UIButton = {
        
        //种类
        let tempView = UIButton()
        tempView.setImage(UIImage(named: "answer_tag"), forState: .Normal)
        tempView.layer.drawsAsynchronously = true
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        tempView.userInteractionEnabled = false
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let answerCountButton: UIButton = {
        
        //回答的数量
        let tempView = UIButton()
        tempView.setImage(UIImage(named: "ic_list_answer_count"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.layer.drawsAsynchronously = true
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        tempView.userInteractionEnabled = false
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    
    

}
