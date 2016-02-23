//
//  YNFillNumberTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/23.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNFillNumberTableViewCellDelegate {

    func fillNumberTableViewCell(cell: YNFillNumberTableViewCell)
}

class YNFillNumberTableViewCell: UITableViewCell, UITextViewDelegate {

    var delegate: YNFillNumberTableViewCellDelegate?
    
    var model: YNVoteItem? {
        
        didSet {
            
            self.nameLabel.text = model?.title
            
        }
    }
    
    
    let nameLabel: UILabel = {
        
        let tempView = UILabel()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.textColor = UIColor.blackColor()
        
        tempView.font = UIFont.boldSystemFontOfSize(15)
        
        tempView.adjustsFontSizeToFitWidth = true
        
        return tempView
        
    }()
    
    let textFilled: YNTextView = {
    
        let tempView = YNTextView()
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textAlignment = .Right
        tempView.placeHolder = "请输入数量"
        
        tempView.layer.cornerRadius = 3
        tempView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        tempView.layer.borderWidth = 0.5
        
        tempView.keyboardType = UIKeyboardType.NumberPad
        
        return tempView
    
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(textFilled)
        
        textFilled.delegate = self
        
        //textFilled
        Layout().addTopConstraint(textFilled, toView: contentView, multiplier: 1, constant: 6)
        Layout().addBottomConstraint(textFilled, toView: contentView, multiplier: 1, constant: -6)
        Layout().addRightConstraint(textFilled, toView: contentView, multiplier: 1, constant: -12)
        Layout().addWidthConstraint(textFilled, toView: nil, multiplier: 1, constant: 90)
        
        //nameLabel
        Layout().addTopBottomConstraints(nameLabel, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(nameLabel, toView: contentView, multiplier: 1, constant: 12)
        Layout().addRightToLeftConstraint(nameLabel, toView: textFilled, multiplier: 1, constant: -12)
     
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UITextViewDelegate
//    func textViewDidChange(textView: UITextView) {
//        
//        self.delegate?.fillNumberTableViewCell(self)
//        
//    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.delegate?.fillNumberTableViewCell(self)
        
    }
    
    
    
}
