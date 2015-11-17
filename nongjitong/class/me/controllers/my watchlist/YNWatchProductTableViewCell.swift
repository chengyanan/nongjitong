//
//  YNWatchProductTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/17.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNWatchProductTableViewCellDelegate {

    func watchProductTableViewCellSelectButtonDidClick(cell: YNWatchProductTableViewCell)
}

class YNWatchProductTableViewCell: UITableViewCell {

    var delegate: YNWatchProductTableViewCellDelegate?
    
    var productModel: YNCategoryModel? {
        
        didSet {
            
            self.nameLabel.text = productModel?.class_name
            
            if productModel!.isSelected {
                
                self.selectButton.selected = true
                
            } else {
                
                self.selectButton.selected = false
            }
            
        }
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setInterface()
        setLayout()
        
        let tgr = UITapGestureRecognizer(target: self, action: "selectButtonDidClick")
        self.contentView.addGestureRecognizer(tgr)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        //selectButton
        Layout().addWidthConstraint(selectButton, toView: nil, multiplier: 0, constant: 12)
        Layout().addHeightConstraint(selectButton, toView: nil, multiplier: 0, constant: 13)
        Layout().addRightConstraint(selectButton, toView: self.contentView, multiplier: 1, constant: -12)
        Layout().addCenterYConstraint(selectButton, toView: self.contentView, multiplier: 1, constant: 0)
        
    
        //nameLabel
        Layout().addTopConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 16)
        Layout().addBottomConstraint(nameLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightToLeftConstraint(nameLabel, toView: selectButton, multiplier: 1, constant: -6)
    }
    
    func setInterface() {
    
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(selectButton)
        
        selectButton.addTarget(self, action: "selectButtonDidClick", forControlEvents: .TouchUpInside)
    }
    
    
    func selectButtonDidClick() {
    
        selectButton.selected = !selectButton.selected
        self.delegate?.watchProductTableViewCellSelectButtonDidClick(self)
    }
    
    let selectButton: UIButton = {
    
        let tempView = UIButton()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.setImage(UIImage(named: "tagUnSelected"), forState: .Normal)
        tempView.setImage(UIImage(named: "tagSelected"), forState: .Selected)
        
        return tempView
    }()
    
    let nameLabel: UILabel = {
    
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    
}
