//
//  YNAskQuestionTextCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNAskQuestionTextCollectionViewCellDelegate {

    func askQuestionTextCollectionViewCellTextViewDidEndEditing(text: String)
}

class YNAskQuestionTextCollectionViewCell: UICollectionViewCell, UITextViewDelegate {

    //MARK: public protory
    var delegate: YNAskQuestionTextCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(inputTextView)
        inputTextView.delegate = self
        
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: UITextViewDelegate
    func textViewDidEndEditing(textView: UITextView) {
        
        self.delegate?.askQuestionTextCollectionViewCellTextViewDidEndEditing(textView.text)
        
    }
    
    func setLayout() {
        
        Layout().addLeftTopBottomConstraints(inputTextView, toView: self.contentView, multiplier: 1, constant: 0)
        
        Layout().addRightConstraint(inputTextView, toView: self.contentView, multiplier: 1, constant: 0)
    }
    
    let inputTextView: YNTextView = {
        
        let tempView = YNTextView()
        tempView.placeHolder = "请输入问题描述"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(17)
        return tempView
        
    }()
    
}
