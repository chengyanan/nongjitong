//
//  YNDocListCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/18.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocListCollectionViewCell: UICollectionViewCell {

    
    var model: YNSearchResaultModel? {
        
        didSet {
            
            if let _ = model {
                
                self.titleLabel.text = model?.title
               
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = kRGBA(209, g: 209, b: 209, a: 1).CGColor
        
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
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textAlignment = .Center
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
    
    
    
}
