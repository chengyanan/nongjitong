//
//  YNMembersCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/29.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNMembersCollectionViewCell: UICollectionViewCell {

    static let identify = "Cell_Members"
    
    var model: YNMemberModel? {
    
        didSet {
        
            titleLabel.text = model?.user_name!
            agreeButton.imageView?.getImageWithURL(model!.avatar!, contentMode: UIViewContentMode.ScaleAspectFill)
        }
    }
    
    let titleLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(13)
        return tempView
        
    }()
    
    let agreeButton: UIButton = {
        
        let tempView = UIButton()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.greenColor()
        tempView.setImage(UIImage(named: "user_default_avatar"), forState: .Normal)
        tempView.setTitleColor(UIColor.blackColor(), forState: .Normal)
        tempView.layer.cornerRadius = 3
        tempView.titleLabel?.font = UIFont.systemFontOfSize(13)
        tempView.clipsToBounds = true
        return tempView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(agreeButton)
        contentView.addSubview(titleLabel)
        
        //agreeButton
        Layout().addTopConstraint(agreeButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(agreeButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(agreeButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addHeightToWidthConstraints(agreeButton, toView: agreeButton, multiplier: 1, constant: 0)
        
        //titleLabel
        Layout().addTopToBottomConstraint(titleLabel, toView: agreeButton, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
