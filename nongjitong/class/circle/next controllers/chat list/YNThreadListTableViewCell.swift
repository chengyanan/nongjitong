//
//  YNThreadListTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/16.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNThreadListTableViewCell: UITableViewCell {

    let marginModel = YNThreadMargin()
    
    var model: YNThreadModel? {
        
        didSet {

            
            self.nickName.text = model?.user_name
            self.postTime.text = model?.add_time
            self.content.text = model?.title
           
            
            self.avatorImage.getImageWithURL(model!.avatar!, contentMode: UIViewContentMode.ScaleToFill)
            
            if model?.photo.count > 0 {
                
                //添加图片
                self.addPictures()
                
                
            } else {
                
                
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.removePictures()
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
    
    func removePictures() {
        
        for view in self.contentView.subviews {
            
            if view is UIImageView {
                
                if view.tag > 0 {
                    
                    view.removeFromSuperview()
                }
                
            }
        }
    }
    
    func addPictures() {
        
        for var i = 0; i < model?.photo.count; i++ {
            
            // 图片最大数量
            if i < 3 {
                //图片最多显示3张
                
                let imageView = UIImageView()
                //            imageView.backgroundColor = UIColor.redColor()
                imageView.tag = i+1
                
                let leftRightMargin = model!.marginModel.leftRightMargin
                
                let imageWidthHeight = model!.marginModel.imageWidthHeight!
                
                let imageY = model!.marginModel.imageY!
                
                let imageMargin = model!.marginModel.imageMargin
                
                let x =  leftRightMargin + CGFloat(i) * imageWidthHeight + CGFloat(i) * imageMargin
                
                imageView.frame = CGRectMake(x, imageY, imageWidthHeight, imageWidthHeight)
                
                imageView.getImageWithURL(model!.photo[i], contentMode: UIViewContentMode.ScaleToFill)
                imageView.clipsToBounds = true
                
                self.contentView.addSubview(imageView)
                
            }
            
            
        }
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
        
        
        //content
        Layout().addLeftConstraint(content, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addRightConstraint(content, toView: self.contentView, multiplier: 1, constant: -marginModel.leftRightMargin)
        Layout().addTopToBottomConstraint(content, toView: avatorImage, multiplier: 1, constant: 15)
        
       
    }
    
    func setInterface() {
        
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        
        self.contentView.addSubview(content)
        
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
        tempView.font = UIFont.boldSystemFontOfSize(13)
        tempView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
    
    
    let content: UILabel = {
        
        //问题内容
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.numberOfLines = 3
        tempView.font = UIFont.systemFontOfSize(15)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //        tempView.backgroundColor = UIColor.whiteColor()
        
        return tempView
    }()
    
    
    
    
}
