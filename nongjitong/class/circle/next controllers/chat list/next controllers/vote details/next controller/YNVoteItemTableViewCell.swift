//
//  YNVoteItemTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/22.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNVoteItemTableViewCellDelegate {

    func voteItemTableViewCellSelectButtonClick(cell: YNVoteItemTableViewCell)
}

class YNVoteItemTableViewCell: UITableViewCell {

    
    var model: YNVoteItem? {
    
        didSet {
        
            self.nameLabel.text = model?.title
            
            if model!.isSelected {
            
                self.selectButton.selected = true
                
            } else {
            
                self.selectButton.selected = false
            }
            
        }
    }
    
    var delegate: YNVoteItemTableViewCellDelegate?
    
    let selectButton: UIButton = {
    
        let tempView = UIButton()
        tempView.setImage(UIImage(named: "voteItemUnselected"), forState: UIControlState.Normal)
        tempView.setImage(UIImage(named: "voteItemSelected"), forState: UIControlState.Selected)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        return tempView
        
    }()
    
    let nameLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.textColor = UIColor.blackColor()
        
        tempView.font = UIFont.boldSystemFontOfSize(15)
        
        return tempView
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(selectButton)
        contentView.addSubview(nameLabel)
        
        self.selectButton.addTarget(self, action: "selectedButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        let tgr = UITapGestureRecognizer(target: self, action: "selectedButtonClick")
        self.contentView.addGestureRecognizer(tgr)
        
        //selectButton
        Layout().addTopBottomConstraints(selectButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(selectButton, toView: contentView, multiplier: 1, constant: 12)
        
        Layout().addWidthConstraint(selectButton, toView: nil, multiplier: 0, constant: 44)
        
        //nameLabel
        Layout().addTopBottomConstraints(nameLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(nameLabel, toView: selectButton, multiplier: 1, constant: 12)
        Layout().addRightConstraint(nameLabel, toView: contentView, multiplier: 1, constant: -12)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    //MARK: event response
    func selectedButtonClick() {
    
        self.selectButton.selected = !self.selectButton.selected
        
        self.model?.isSelected = self.selectButton.selected
     
        self.delegate?.voteItemTableViewCellSelectButtonClick(self)
        
    }
    
    
    
    
    
    
}
