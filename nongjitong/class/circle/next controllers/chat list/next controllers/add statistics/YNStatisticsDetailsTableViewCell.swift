//
//  YNStatisticsDetailsTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/24.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNStatisticsDetailsTableViewCell: UITableViewCell {

    var model: YNStatisticsDetailsModel? {
    
        didSet {
        
            self.avatorImage.getImageWithURL(model!.avatar!, contentMode: UIViewContentMode.ScaleAspectFill)
            
            self.nickName.text = model?.user_name
            self.valueLabel.text = model?.value
            
        }
    }
    
    let avatorImage: UIImageView = {
        
        //头像
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        tempView.layer.cornerRadius = 15
        tempView.clipsToBounds = true
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let nickName: UILabel = {
        
        //昵称
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.boldSystemFontOfSize(15)
        tempView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        //        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let valueLabel: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        tempView.textAlignment = .Right
        //        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(avatorImage)
        contentView.addSubview(nickName)
        contentView.addSubview(valueLabel)
        
        //avatorImage
        Layout().addLeftConstraint(avatorImage, toView: contentView, multiplier: 1, constant: 12)
        Layout().addCenterYConstraint(avatorImage, toView: contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(avatorImage, toView: nil, multiplier: 1, constant: 30)
        Layout().addHeightConstraint(avatorImage, toView: nil, multiplier: 1, constant: 30)
        
        //valueLabel
        Layout().addTopBottomConstraints(valueLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(valueLabel, toView: contentView, multiplier: 1, constant: -12)
        Layout().addWidthConstraint(valueLabel, toView: nil, multiplier: 0, constant: 80)
        
        //nickName
        Layout().addTopBottomConstraints(nickName, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 8)
        Layout().addRightToLeftConstraint(nickName, toView: valueLabel, multiplier: 1, constant: -8)
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
