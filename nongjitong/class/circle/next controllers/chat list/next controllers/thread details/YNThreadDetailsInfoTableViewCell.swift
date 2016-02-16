//
//  YNThreadDetailsInfoTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/16.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNThreadDetailsInfoTableViewCell: UITableViewCell {

    
    let marginModel = YNThreadMargin()
    
    var model: YNThreadModel? {
        
        didSet {
                    
            self.nickName.text = model?.user_name
            self.postTime.text = model?.add_time
            
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
        Layout().addHeightConstraint(nickName, toView: nil, multiplier: 0, constant: 24)
        
        //postTime
        Layout().addLeftConstraint(postTime, toView: nickName, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(postTime, toView: nickName, multiplier: 1, constant: 2)
        Layout().addBottomConstraint(postTime, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(postTime, toView: nil, multiplier: 0, constant: 80)
        
        
    }
    
    func setInterface() {
        
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        
    }
    
    
    let avatorImage: UIImageView = {
        
        //头像
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let nickName: UILabel = {
        
        //昵称
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.boldSystemFontOfSize(17)
        //        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let postTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        //        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    
    
}
