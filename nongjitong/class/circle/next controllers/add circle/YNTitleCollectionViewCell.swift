//
//  YNTitleCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/27.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit


protocol YNTitleCollectionViewCellDelegate {

    func titleCollectionViewCell(cell: YNTitleCollectionViewCell, text: String)
    
}

class YNTitleCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var delegate: YNTitleCollectionViewCellDelegate?
    
    let textView: YNTextView = {
    
        let tempView = YNTextView()
        tempView.placeHolder = "请输入标题"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(15)
        return tempView
    
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(textView)
        
        textView.delegate = self
        
        Layout().addTopConstraint(textView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(textView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(textView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(textView, toView: contentView, multiplier: 1, constant: 0)
        
        
    }
    
    //MARK: UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        
        self.delegate?.titleCollectionViewCell(self, text: textView.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
}
