//
//  YNNewstagCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewstagCollectionViewCell: UICollectionViewCell {

    static let identify = "Cell_News_tag"
    
    var title: String? {
    
        didSet {
        
            self.titleLabel.text = title
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
        tempView.backgroundColor = UIColor(red: 100/255.0, green: 189/255.0, blue: 62/255.0, alpha: 1)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textAlignment = .Center
        tempView.font = UIFont.systemFontOfSize(11)
        
        tempView.layer.cornerRadius = 6
        tempView.clipsToBounds = true
        tempView.textColor = UIColor.whiteColor()
        return tempView
        
    }()
    
    
}
