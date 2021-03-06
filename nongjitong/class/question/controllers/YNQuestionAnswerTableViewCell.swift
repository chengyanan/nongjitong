//
//  YNQuestionAnswerTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/18.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNQuestionAnswerTableViewCellDelegate {

    func questionAnswerTableViewCellHasAcceptAnswer(IndexPath: NSIndexPath)
}

class YNQuestionAnswerTableViewCell: UITableViewCell {
    
    var dataIndexPath: NSIndexPath?
    var delegate: YNQuestionAnswerTableViewCellDelegate?
    var isAcceptAnswer = false
    var answeModel: YNAnswerModel? {
    
        didSet {
            
            self.questionContent.text = answeModel?.content
            self.avatorImage.getImageWithURL(answeModel!.avatar!, contentMode: UIViewContentMode.ScaleToFill)
            self.nickName.text = answeModel?.user_name
            self.postTime.text = answeModel?.add_time
            
            //判断是否被踩纳
            if answeModel?.is_accept == "Y" {
            
                //被采纳
                self.acceptImage.hidden = false
                self.acceptAnswer.hidden = true
                
            } else {
                
                 //没有被采纳
                if isAcceptAnswer {
                    
                    //问题已解决
                    self.acceptImage.hidden = true
                    self.acceptAnswer.hidden = true
                    
                } else {
                    
                    //问题没解决
                    self.acceptImage.hidden = true
                    
                    if answeModel!.isQuestionOwner! {
                        
                        acceptAnswer.hidden = false
                        
                    } else {
                        
                        acceptAnswer.hidden = true
                    }
                }
                
            }
            
            setLayout()
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setInterface()
        
        acceptAnswer.addTarget(self, action: "acceptButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        let acceptImageWidth: CGFloat = 32.5
        let acceptImageHeight: CGFloat = 33
        
        let acceptImageX = kScreenWidth - acceptImageWidth
        
        acceptImage.frame = CGRectMake(acceptImageX, 0, acceptImageWidth, acceptImageHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: event resopnse
    func acceptButtonClick() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "acceptAnswer",
            "question_id": answeModel?.questionId,
            "user_id": answeModel?.user_id
        ]
        
        YNHttpQuestionDetail().acceptAnswerWithParams(params, successFull: { (json) -> Void in
            
            
            if let status = json["status"] as? Int {
                
//                print(json)
                
                if status == 1 {
                    
                    self.acceptImage.hidden = false
                    self.acceptAnswer.hidden = true
                    //通知代理 问题已采纳 不需要再显示采纳按钮
                    self.delegate?.questionAnswerTableViewCellHasAcceptAnswer(self.dataIndexPath!)
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        print("接口请求失败: \(msg)")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                print("网络出错")
        }
        
    }
    
    func setInterface() {
    
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        self.contentView.addSubview(questionContent)
        self.contentView.addSubview(acceptAnswer)
        self.contentView.addSubview(acceptImage)
    
    }
    
    func setLayout() {
        
        if let _  = answeModel {
        
            //acceptImage
            
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
//        tempView.backgroundColor = UIColor.redColor()
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
    
    let acceptImage: UIImageView = {
        
        //接纳的标志
        let tempView = UIImageView()
        tempView.image = UIImage(named: "newqb_evaluate_best")
        tempView.hidden = true
        tempView.clipsToBounds = true
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
}
