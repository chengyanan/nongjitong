//
//  YNSunscriptionTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNSunscriptionTableViewCell: UITableViewCell {
    
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
    
        //nameLabel
        Layout().addTopConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 3)
        Layout().addLeftConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 12)
        Layout().addWidthConstraint(nameLabel, toView: nil, multiplier: 0, constant: 80)
        Layout().addHeightConstraint(nameLabel, toView: nil, multiplier: 1, constant: 44)
        
        //scaleLabel
        Layout().addTopConstraint(scaleLabel, toView: nameLabel, multiplier: 1, constant: 6)
        Layout().addRightConstraint(scaleLabel, toView: self.contentView, multiplier: 1, constant: -12)
        Layout().addWidthConstraint(scaleLabel, toView: nil, multiplier: 0, constant: 80)
        Layout().addHeightConstraint(scaleLabel, toView: nil, multiplier: 0, constant: 16)
        
        //locationLabel
        Layout().addTopToBottomConstraint(locationLabel, toView: scaleLabel, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(locationLabel, toView: nameLabel, multiplier: 1, constant: 0)
        Layout().addRightConstraint(locationLabel, toView: scaleLabel, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(locationLabel, toView: nameLabel, multiplier: 1, constant: 12)
        
        //separatorView
        Layout().addTopToBottomConstraint(separatorView, toView: nameLabel, multiplier: 1, constant: 3)
        Layout().addLeftConstraint(separatorView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(separatorView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(separatorView, toView: nil, multiplier: 0, constant: 0.6)
        
        //blankView
        Layout().addTopToBottomConstraint(blankView, toView: separatorView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(blankView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(blankView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(blankView, toView: self.contentView, multiplier: 1, constant: 0)
    }
    
    func setInterface() {
    
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(scaleLabel)
        self.contentView.addSubview(locationLabel)
        self.contentView.addSubview(separatorView)
        self.contentView.addSubview(blankView)
    }
    

    let nameLabel: UILabel =  {
        
        //种类名称
        let tempView = UILabel()
        tempView.text = "花生"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let scaleLabel: UILabel =  {
        //规模
        let tempView = UILabel()
        tempView.text = "100亩"
        tempView.textAlignment = .Right
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let locationLabel: UILabel =  {
        //地址
        let tempView = UILabel()
        tempView.text = "郑州市, 郑东新区"
        tempView.textAlignment = .Right
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let separatorView: UIView = {
    
        let tempView = UIView()
        tempView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let blankView: UIView = {
        
        let tempView = UIView()
        tempView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
}
