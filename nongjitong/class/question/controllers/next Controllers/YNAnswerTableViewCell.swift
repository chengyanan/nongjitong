//
//  YNAnswerTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNAnswerTableViewCellDelegate {

    func answered(indexPath: NSIndexPath)
}

class YNAnswerTableViewCell: UITableViewCell {
    
    var indexPath: NSIndexPath?
    
    var delegate: YNAnswerTableViewCellDelegate?
    
    var questionModel: YNAnswerModel? {
    
        didSet {
        
            if let _ = questionModel {
                
                setInterface()
                setLayout()
                
                //设置头像 和文字
                self.contentButton.setTitle(questionModel?.content, forState: .Normal)
                if let _ = questionModel!.avatar {
                
                     self.avatarImageView.getImageWithURL(questionModel!.avatar!, contentMode: .ScaleToFill)
                }
               
                
                if questionModel!.isQuestionOwner! {
                  self.contentButton.setBackgroundImage(resizeImage("bubble_left_blue"), forState: .Normal)
                    
                } else {
                
                    self.contentButton.setBackgroundImage(resizeImage("bubble_green"), forState: .Normal)
                }
                
                //设置加载条和加载结果
                if questionModel!.isFinish {
            
                    
                } else {
                
                    //加载数据
                    sendMessageToserver()
                }
                
                
            }
            
        }
    }

    
    func sendMessageToserver() {
        
        let userId = kUser_ID() as? String
        let username = kUser_NiceName() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Answer",
            "a": "answer",
            "question_id": questionModel!.questionId,
            "user_id": userId,
            "user_name": username,
            "content": questionModel?.content,
            "to_user_id": questionModel?.to_user_id
        ]
        
        print("userId: \(userId), touserid: \(questionModel?.to_user_id)")
        
        self.sendButton.hidden = true
        self.activityIndicatorView.startAnimating()
        YNHttpAnswerQuestion().answerWithParams(params, successFull: { (json) -> Void in
            
            self.activityIndicatorView.stopAnimating()
            
            //            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    
                    print("回答成功")
                    self.delegate?.answered(self.indexPath!)
                    
                } else if status == 0 {
                    
                    self.sendButton.hidden = false
                    
                    if let msg = json["msg"] as? String {
                        
                        print(msg)
                        
                        
                    }
                }
                
            }
            
            
            }, failureFul: { (error) -> Void in
                
                self.activityIndicatorView.stopAnimating()
                
                self.sendButton.hidden = false
                
        })
        
    }
    
    func resizeImage(name: String) -> UIImage{
    
        let image = UIImage(named: name)
        
        let top =  image!.size.height * 0.6
        let bottom = image!.size.height - top
        let left = image!.size.width * 0.5
        
        let newimage = image!.resizableImageWithCapInsets(UIEdgeInsets(top: top, left: left, bottom: bottom, right: left), resizingMode: .Stretch)
        
        return newimage
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.sendButton.addTarget(self, action: "sendMessageToserver", forControlEvents: .TouchUpInside)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        self.contentView.removeConstraints(self.contentView.constraints)
        
        self.avatarImageView.removeFromSuperview()
        self.contentButton.removeFromSuperview()
        self.activityIndicatorView.removeFromSuperview()
        self.sendButton.removeFromSuperview()
    }
    
    func setInterface() {
    
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(contentButton)
        self.contentView.addSubview(activityIndicatorView)
        self.contentView.addSubview(sendButton)
    }
    
    //头像
    let avatarImageView: UIImageView = {
    
        let tempView = UIImageView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
//        tempView.image = UIImage(named: "admin")
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
//        tempView.titleLabel?.textAlignment = .Center
        return tempView
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
    
        let tempView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.hidesWhenStopped = true
        return tempView
    }()
    
    let sendButton: UIButton = {
    
        let tempView = UIButton()
        tempView.hidden = true
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.setBackgroundImage(UIImage(named: "chatroom_msg_failed"), forState: .Normal)
        return tempView
        
    }()
    
    func setLayout() {
    
        //avatarImageView
        Layout().addTopConstraint(avatarImageView, toView: self.contentView, multiplier: 1, constant: questionModel!.marginTopBottomLeftOrRight)
        Layout().addWidthHeightConstraints(avatarImageView, toView: nil, multiplier: 1, constant: questionModel!.avatarWidthHeight)
        
        if self.questionModel!.isQuestionOwner! {
            
            //avatarImageView
            Layout().addLeftConstraint(avatarImageView, toView: self.contentView, multiplier: 1, constant: questionModel!.marginTopBottomLeftOrRight)
            
            //contentLabel
            Layout().addLeftToRightConstraint(contentButton, toView: avatarImageView, multiplier: 1, constant: questionModel!.marginBetweenAvatarAndContent)
            
            
        } else {
            
            //avatarImageView
            Layout().addRightConstraint(avatarImageView, toView: self.contentView, multiplier: 1, constant: -questionModel!.marginTopBottomLeftOrRight)
            
            //contentLabel
            Layout().addRightToLeftConstraint(contentButton, toView: avatarImageView, multiplier: 1, constant: -questionModel!.marginBetweenAvatarAndContent)
            
        }
        
        Layout().addTopConstraint(contentButton, toView: avatarImageView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(contentButton, toView: nil, multiplier: 0, constant: questionModel!.contentSize.height)
        Layout().addWidthConstraint(contentButton, toView: nil, multiplier: 0, constant: questionModel!.contentSize.width)
        
        
        //activityIndicatorView
        Layout().addCenterYConstraint(activityIndicatorView, toView: contentButton, multiplier: 1, constant: 0)
        Layout().addWidthHeightConstraints(activityIndicatorView, toView: nil, multiplier: 0, constant: 22)
        
        //sendButton
        Layout().addCenterYConstraint(sendButton, toView: contentButton, multiplier: 1, constant: 0)
        Layout().addWidthHeightConstraints(sendButton, toView: nil, multiplier: 0, constant: 22)
        
        if self.questionModel!.isQuestionOwner! {
            
            //activityIndicatorView
            Layout().addLeftToRightConstraint(activityIndicatorView, toView: contentButton, multiplier: 1, constant: 0)
            
            //sendButton
            Layout().addLeftToRightConstraint(sendButton, toView: contentButton, multiplier: 1, constant: 0)
            
        } else {
            
            //activityIndicatorView
            Layout().addRightToLeftConstraint(activityIndicatorView, toView: contentButton, multiplier: 1, constant: 6)
            
            //sendButton
            Layout().addRightToLeftConstraint(sendButton, toView: contentButton, multiplier: 1, constant: 6)
        }
    }
    
    
  
}
