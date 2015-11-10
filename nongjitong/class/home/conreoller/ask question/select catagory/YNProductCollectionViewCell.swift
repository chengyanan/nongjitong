//
//  YNProductCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/9.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNProductCollectionViewCell: UICollectionViewCell {

    
    var productModel: YNCategoryModel? {
        
        didSet {
            
            self.nameLabel.text = productModel?.class_name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
