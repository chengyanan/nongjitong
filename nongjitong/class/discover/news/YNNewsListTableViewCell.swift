//
//  YNNewsListTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/3.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsListTableViewCell: UITableViewCell {

    var model: YNNewsModel? {
    
        didSet {
        
            self.newsImage.getImageWithURL(model!.photo!, contentMode: UIViewContentMode.ScaleAspectFill)
            
            self.newsTitle.text = model?.title
            self.sourceLabel.text = "来自: \(model!.source!)"
            self.authorLabel.text = "作者: \(model!.user_name!)"
            self.postTime.text = model?.add_time
            self.readTimes.setTitle("查看次数: \(model!.order_num!)", forState: .Normal)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        contentView.addSubview(newsTitle)
        contentView.addSubview(newsImage)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(postTime)
        contentView.addSubview(readTimes)
        
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        //newsImage
        Layout().addTopConstraint(newsImage, toView: contentView, multiplier: 1, constant: 10)
        Layout().addRightConstraint(newsImage, toView: contentView, multiplier: 1, constant: -10)
        Layout().addWidthConstraint(newsImage, toView: nil, multiplier: 0, constant: 60)
        Layout().addHeightConstraint(newsImage, toView: nil, multiplier: 0, constant: 50)
        
        
        //newsTitle
        Layout().addTopConstraint(newsTitle, toView: contentView, multiplier: 1, constant: 10)
        Layout().addLeftConstraint(newsTitle, toView: contentView, multiplier: 1, constant: 10)
        Layout().addHeightConstraint(newsTitle, toView: nil, multiplier: 1, constant: 36)
        Layout().addRightToLeftConstraint(newsTitle, toView: newsImage, multiplier: 1, constant: -10)
        
        //sourceLabel
        Layout().addTopToBottomConstraint(sourceLabel, toView: newsTitle, multiplier: 1, constant: 8)
        Layout().addLeftConstraint(sourceLabel, toView: newsTitle, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(sourceLabel, toView: newsTitle, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(sourceLabel, toView: nil, multiplier: 0, constant: 12)
        
        //authorLabel
        Layout().addTopToBottomConstraint(authorLabel, toView: sourceLabel, multiplier: 1, constant: 10)
        Layout().addLeftConstraint(authorLabel, toView: sourceLabel, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(authorLabel, toView: sourceLabel, multiplier: 0.6, constant: 0)
        Layout().addHeightConstraint(authorLabel, toView: nil, multiplier: 0, constant: 20)
        
        //postTime
        Layout().addTopBottomConstraints(postTime, toView: authorLabel, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(postTime, toView: authorLabel, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(postTime, toView: sourceLabel, multiplier: 0.4, constant: 0)
        
        //readTimes
        Layout().addTopBottomConstraints(readTimes, toView: postTime, multiplier: 1, constant: 0)
        Layout().addRightConstraint(readTimes, toView: newsImage, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(readTimes, toView: newsImage, multiplier: 1, constant: 0)
        
        
        
    }
    
    //MARK: interface UI
    let newsTitle: UILabel = {
        
        //标题
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.numberOfLines = 2
        tempView.font = UIFont.systemFontOfSize(15)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        return tempView
    }()
    
    let newsImage: UIImageView = {
        
        //图片
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        return tempView
    }()
    
    let sourceLabel: UILabel = {
        
        //信息来源
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.boldSystemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        return tempView
    }()
    
    let authorLabel: UILabel = {
        
        //发布者
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor(red: 114/255.0, green: 114/255.0, blue: 124/255.0, alpha: 1)
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
    
    let postTime: UILabel = {
        
        //发布时间
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
    
    let readTimes: UIButton = {
        
        //阅读次数
        let tempView = UIButton()
//        tempView.setImage(UIImage(named: "home_page_location_image"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        tempView.userInteractionEnabled = false
        return tempView
    }()
    
    
//    let answerCountButton: UIButton = {
//        
//        //回答的数量
//        let tempView = UIButton()
//        tempView.setImage(UIImage(named: "ic_list_answer_count"), forState: .Normal)
//        tempView.translatesAutoresizingMaskIntoConstraints = false
//        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
//        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
//        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
//        tempView.userInteractionEnabled = false
//        //        tempView.backgroundColor = UIColor.whiteColor()
//        return tempView
//    }()
    
    
    
}
