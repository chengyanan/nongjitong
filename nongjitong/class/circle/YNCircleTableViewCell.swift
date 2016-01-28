//
//  YNCircleTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit


protocol YNCircleTableViewCellDelegate {

    func circleTableViewCellDontLoginin(cell: YNCircleTableViewCell)
    
    func circleTableViewCellGotoReasonPage(cell: YNCircleTableViewCell)
    
    func circleTableViewCellIsMembership(cell: YNCircleTableViewCell)
}

class YNCircleTableViewCell: UITableViewCell {

    static let constantHeight: CGFloat = 66
    
    var delegate: YNCircleTableViewCellDelegate?
    
    var model: YNCircleModel? {
    
        didSet {
        
            self.titleLabel.text = model?.title!
            self.announcement.text = model?.announcement!
        }
    }
    
    let requestButton: UIButton = {
    
        let tempView = UIButton()
        tempView.setTitle("申请加入", forState: UIControlState.Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(13)
        tempView.backgroundColor = UIColor.blueColor()
        tempView.layer.cornerRadius = 3
        tempView.clipsToBounds = true
        return tempView
    }()
    
    let titleLabel: UILabel = {
    
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(15)
        return tempView
        
    }()
    
    let announcement: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textColor = UIColor.lightGrayColor()
        tempView.font = UIFont.systemFontOfSize(13)
        return tempView
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(announcement)
        contentView.addSubview(requestButton)
        
        self.accessoryType = .DisclosureIndicator
        self.selectionStyle = .None
        
        //titleLabel
        Layout().addTopConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 10)
        Layout().addLeftConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 12)
        Layout().addRightConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 60)
        Layout().addHeightConstraint(titleLabel, toView: nil, multiplier: 0, constant: 20)
        
        //announcement
        Layout().addTopToBottomConstraint(announcement, toView: titleLabel, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(announcement, toView: titleLabel, multiplier: 1, constant: 0)
        Layout().addRightConstraint(announcement, toView: titleLabel, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(announcement, toView: nil, multiplier: 0, constant: 36)
        
        //requestButton
        Layout().addRightConstraint(requestButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addCenterYConstraint(requestButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(requestButton, toView: nil, multiplier: 1, constant: 38)
        Layout().addWidthConstraint(requestButton, toView: nil, multiplier: 0, constant: 58)
        
        requestButton.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: event response
    func addButtonClick() {
    
        let userId = kUser_ID() as? String
        
        if let _ = userId {
            
             //TODO: 判断是否是群成员
            self.delegate?.circleTableViewCellIsMembership(self)
        
//            //已登陆通知代理跳申请理由界面
//            self.delegate?.circleTableViewCellGotoReasonPage(self)
            
        } else {
        
            //未登录通知代理跳登录界面
            self.delegate?.circleTableViewCellDontLoginin(self)
        }
        
        
    }
    
    
    
  
    
    
}
