//
//  YNNewsCommentTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsCommentTableViewCell: UITableViewCell {

    var model: YNNewsCommentModel? {
    
        didSet {
        
            self.avatorImage.getImageWithURL(model!.avatar!, contentMode: .ScaleAspectFill)
            
            self.nickName.text = model?.user_name
            self.postTime.text = model?.add_time
            self.content.text = model?.content
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        setInterface()
        setLayout()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    func setLayout() {
        
        //avatorImage
        Layout().addTopConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: YNNewsCommentModel.top)
        
        Layout().addLeftConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: YNNewsCommentModel.leftRightMargin)
        Layout().addHeightConstraint(avatorImage, toView: nil, multiplier: 0, constant: YNNewsCommentModel.avatarHeight)
        Layout().addWidthConstraint(avatorImage, toView: nil, multiplier: 0, constant: YNNewsCommentModel.avatarHeight)
        
        //nickName
        Layout().addTopConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 5)
        Layout().addRightConstraint(nickName, toView: self.contentView, multiplier: 1, constant: -YNNewsCommentModel.leftRightMargin)
        Layout().addHeightConstraint(nickName, toView: nil, multiplier: 0, constant: 18)
        
        //postTime
        Layout().addLeftConstraint(postTime, toView: nickName, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(postTime, toView: nickName, multiplier: 1, constant: 2)
        Layout().addBottomConstraint(postTime, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(postTime, toView: nil, multiplier: 0, constant: 80)
        
        //content
        Layout().addLeftConstraint(content, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addRightConstraint(content, toView: self.contentView, multiplier: 1, constant: -YNNewsCommentModel.leftRightMargin)
        Layout().addTopToBottomConstraint(content, toView: avatorImage, multiplier: 1, constant: YNNewsCommentModel.avatorContentMargin)

        
    }
    
    func setInterface() {
        
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        self.contentView.addSubview(content)
       
    }
    
    
    //MARK: interface UI
    let avatorImage: UIImageView = {
        
        //头像
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        return tempView
    }()
    
    let nickName: UILabel = {
        
        //昵称
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.boldSystemFontOfSize(12)
        tempView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        return tempView
    }()
    
    let postTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
    
    
    let content: UILabel = {
        
        //内容
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.numberOfLines = 3
        tempView.font = UIFont.systemFontOfSize(12)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        return tempView
    }()
    
    
    
    
}
