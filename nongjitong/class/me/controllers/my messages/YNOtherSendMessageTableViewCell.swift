//
//  YNOtherSendMessageTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNOtherSendMessageTableViewCell: UITableViewCell {
    
    
    var model: YNMessageModel? {
    
        didSet {
        
            
            self.titleLabel.text = model?.content
            
            
            if model?.status == "0" {
            
                self.rejectButton.hidden = false
                self.rejectButton.setTitle("拒绝", forState: .Normal)
                self.agreeButton.setTitle("同意", forState: .Normal)
                self.agreeButton.userInteractionEnabled = true
                
            } else if model?.status == "1" {
            
                self.rejectButton.hidden = true
                self.agreeButton.setTitle("已同意", forState: .Normal)
                self.agreeButton.userInteractionEnabled = false
                self.agreeButton.backgroundColor = UIColor.clearColor()
                
            } else if model?.status == "2" {
                
                self.rejectButton.hidden = true
                self.agreeButton.setTitle("已拒绝", forState: .Normal)
                self.agreeButton.userInteractionEnabled = false
                self.agreeButton.backgroundColor = UIColor.clearColor()
            }
            
            
        }
    }
    

    let titleLabel: UILabel = {
        
        let tempView = UILabel()
        tempView.numberOfLines = 0
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(13)
        return tempView
        
    }()
    
//    let reasonLabel: UILabel = {
//        
//        let tempView = UILabel()
//        tempView.numberOfLines = 0
//        tempView.translatesAutoresizingMaskIntoConstraints = false
//        tempView.font = UIFont.systemFontOfSize(13)
//        return tempView
//        
//    }()
    
    let agreeButton: UIButton = {
    
        let tempView = UIButton()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.greenColor()
        tempView.setTitle("同意", forState: UIControlState.Normal)
        tempView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tempView.layer.cornerRadius = 3
        tempView.titleLabel?.font = UIFont.systemFontOfSize(13)
        tempView.clipsToBounds = true
        return tempView
    }()
    
    let rejectButton: UIButton = {
        
        let tempView = UIButton()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.redColor()
        tempView.setTitle("拒绝", forState: UIControlState.Normal)
        tempView.titleLabel?.font = UIFont.systemFontOfSize(13)
        tempView.layer.cornerRadius = 3
        tempView.clipsToBounds = true
        return tempView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        contentView.addSubview(titleLabel)
//        contentView.addSubview(reasonLabel)
        contentView.addSubview(agreeButton)
        contentView.addSubview(rejectButton)
        
        setLayout()
        
        agreeButton.addTarget(self, action: "aggreeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        rejectButton.addTarget(self, action: "rejectButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
    }

    //MARK: event response
    func aggreeButtonClick() {
    
        aggreeOrReject("1")
    }
    
    func rejectButtonClick() {
    
        aggreeOrReject("2")
    }
    
    func aggreeOrReject(state: String) {
    
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupUserVerifyMessage",
            "a": "handleMessage",
            "message_id": model?.id,
            "user_id": kUser_ID() as? String,
            "status": state
        ]
        
        let progress = YNProgressHUD().showWaitingToView(UIApplication.sharedApplication().keyWindow!)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        
                        if state == "1" {
                        
                            //同意处理成功
                            self.rejectButton.hidden = true
                            
                            self.agreeButton.setTitle("已同意", forState: UIControlState.Normal)
                            self.agreeButton.userInteractionEnabled = false
                            self.agreeButton.backgroundColor = UIColor.clearColor()
                            
                        } else if state == "2" {
                        
                            //拒绝处理成功
                            self.rejectButton.hidden = true
                            
                            self.agreeButton.setTitle("已拒绝", forState: UIControlState.Normal)
                            self.agreeButton.backgroundColor = UIColor.clearColor()
                            self.agreeButton.userInteractionEnabled = false
                        }
                        
                            
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: UIApplication.sharedApplication().keyWindow!)
                        }
                    }
                    
                }
                
                
            } catch {
                
                YNProgressHUD().showText("请求失败", toView: UIApplication.sharedApplication().keyWindow!)
                
            }
            
            
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: UIApplication.sharedApplication().keyWindow!)
        }
        
        
    }
    
    func setLayout() {
    
        //agreeButton
        Layout().addRightConstraint(agreeButton, toView: contentView, multiplier: 1, constant: -10)
        Layout().addCenterYConstraint(agreeButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(agreeButton, toView: nil, multiplier: 0, constant: 44)
        Layout().addHeightConstraint(agreeButton, toView: nil, multiplier: 0, constant: 30)
        
        //rejectButton
        Layout().addCenterYConstraint(rejectButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(rejectButton, toView: nil, multiplier: 0, constant: 44)
        Layout().addHeightConstraint(rejectButton, toView: nil, multiplier: 0, constant: 30)
        Layout().addRightToLeftConstraint(rejectButton, toView: agreeButton, multiplier: 1, constant: -6)
        
        //titleLabel
        Layout().addTopBottomConstraints(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 12)
        Layout().addRightToLeftConstraint(titleLabel, toView: rejectButton, multiplier: 1, constant: -3)
        
//        //reasonLabel
//        Layout().addTopToBottomConstraint(reasonLabel, toView: titleLabel, multiplier: 1, constant: 3)
//        Layout().addLeftConstraint(reasonLabel, toView: titleLabel, multiplier: 1, constant: 0)
//        Layout().addRightConstraint(reasonLabel, toView: titleLabel, multiplier: 1, constant: 0)
//        Layout().addBottomConstraint(reasonLabel, toView: contentView, multiplier: 1, constant: 0)
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
