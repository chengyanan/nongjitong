//
//  YNAskQuestionImageCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAskQuestionImageCollectionViewCell: UICollectionViewCell {

    
    //MARK: public proporty
    
    var cameraImage: UIImage? {
    
        didSet {
        
            self.imageButton.setImage(cameraImage!, forState: UIControlState.Normal)
            self.deleteButton.hidden = true
        }
    }
    
    var image: UIImage? {
    
        didSet{
        
            self.imageButton.setBackgroundImage(image!, forState: UIControlState.Normal)
            self.deleteButton.hidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         self.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(imageButton)
        self.contentView.addSubview(deleteButton)
        
        setLayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setLayout() {
    
        Layout().addTopConstraint(imageButton, toView: self.contentView, multiplier: 1, constant: 6)
        Layout().addBottomConstraint(imageButton, toView: self.contentView, multiplier: 1, constant: -6)
        Layout().addLeftConstraint(imageButton, toView: self.contentView, multiplier: 1, constant: 6)
        Layout().addRightConstraint(imageButton, toView: self.contentView, multiplier: 1, constant: -6)
        
        Layout().addTopConstraint(deleteButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(deleteButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addWidthHeightConstraints(deleteButton, toView: nil, multiplier: 0, constant: 40)
        
    }
    
    let imageButton: UIButton = {
        
        var tempView = UIButton()
        tempView.backgroundColor =  UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        tempView.setImage(UIImage(named: "home_ask_question_camera"), forState: UIControlState.Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    } ()
    
    let deleteButton: UIButton = {
        
        var tempView = UIButton()
        tempView.hidden = true
        tempView.setImage(UIImage(named: "home_ask_qusetion_delete"), forState: UIControlState.Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    } ()
    
}
