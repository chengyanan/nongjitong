//
//  YNQuestionCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/18.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionCollectionViewCell: UICollectionViewCell {
    
    
    var productModel: YNSelectedProductModel? {
        
        didSet {
            
            if let _ = productModel {
                
                self.titleLabel.text = productModel!.class_name
                
                if productModel!.isSelected {
                
                    self.titleLabel.textColor = UIColor(red: 36/255.0, green: 163/255.0, blue: 65/255.0, alpha: 1)
                    
                } else {
                
                    self.titleLabel.textColor = UIColor.blackColor()
                }
                
                
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        
        setInterface()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
        
        self.contentView.addSubview(titleLabel)
    }
    
    func setLayout() {
        
        Layout().addLeftTopBottomConstraints(titleLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(titleLabel, toView: self.contentView, multiplier: 1, constant: 0)
    }
    
    let titleLabel: UILabel =  {
        
        let tempView = UILabel()
//        tempView.backgroundColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textAlignment = .Center
        tempView.font = UIFont.systemFontOfSize(17)
        return tempView
    }()
    

}
