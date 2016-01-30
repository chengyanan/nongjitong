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
            
            imageView.getImageWithURL(model!.avatar!, contentMode: .ScaleAspectFill)
            
        }
    }
    
    let titleLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.textAlignment = .Center
        return tempView
        
    }()
    
    let imageView: UIImageView = {
        
        let tempView = UIImageView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.layer.cornerRadius = 3
        tempView.clipsToBounds = true
        tempView.contentMode = .ScaleAspectFill
        return tempView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        //agreeButton
        Layout().addTopConstraint(imageView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(imageView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(imageView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addHeightToWidthConstraints(imageView, toView: imageView, multiplier: 1, constant: 0)
        
        //titleLabel
        Layout().addTopToBottomConstraint(titleLabel, toView: imageView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(titleLabel, toView: contentView, multiplier: 1, constant: 0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
