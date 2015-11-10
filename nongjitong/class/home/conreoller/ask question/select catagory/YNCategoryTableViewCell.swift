//
//  YNCategoryTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/9.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNCategoryTableViewCell: UITableViewCell {

    var categoryModel: YNCategoryModel? {
    
        didSet {
        
            self.nameLabel.text = categoryModel?.class_name
            
            if categoryModel!.isSelected {
                
                self.nameLabel.textColor = UIColor.blueColor()
                self.backgroundColor = UIColor.whiteColor()
                
            } else {
            
                self.nameLabel.textColor = UIColor.blackColor()
                self.backgroundColor = kRGBA(215, g: 215, b: 215, a: 1)
            }
            
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
    
    
    func setInterface() {
    
        self.contentView.addSubview(nameLabel)
    }
    
    func setLayout() {
    
        //nameLabel
        Layout().addLeftTopRightConstraints(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
    }
    
    let nameLabel: UILabel = {
    
        let tempView = UILabel()
        tempView.textAlignment = .Center
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
}
