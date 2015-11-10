//
//  YNAskQuestionLocationCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit
import CoreLocation

class YNAskQuestionLocationCollectionViewCell: UICollectionViewCell {

    var imageName: String? {
    
        didSet {
        
            if let tempImage = imageName {
            
                locationButton.setImage(UIImage(named: tempImage), forState: UIControlState.Normal)
                
            } else {
            
                locationButton.setImage(nil, forState: UIControlState.Normal)
            }
        }
    }
    
    var title: String? {
    
        didSet {
        
            locationButton.setTitle(title, forState: UIControlState.Normal)
        }
    }
    
    var detaileTitle: String? {
    
        didSet {
        
            locationLabel.text = detaileTitle
        }
    }
    
    var isShowRightError: Bool = false {
    
        didSet {
        
            if isShowRightError {
            
                rightArror.hidden = false
                locationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
                
            } else {
            
                rightArror.hidden = true
                locationButton.imageEdgeInsets = UIEdgeInsetsZero
            }
        }
    }
    
    //MARK: public proporty
    var coorinate: CLLocationCoordinate2D? {
    
        didSet {
        
            if coorinate != nil {
            
                
                
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(locationButton)
        self.contentView.addSubview(locationLabel)
        self.contentView.addSubview(rightArror)
        
        setLayout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
    
        //locationButton
        Layout().addLeftConstraint(locationButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addTopBottomConstraints(locationButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(locationButton, toView: nil, multiplier: 0, constant: 100)
        
        //locationLabel
        Layout().addTopBottomConstraints(locationLabel, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(locationLabel, toView: self.contentView, multiplier: 1, constant: -18)
        Layout().addLeftToRightConstraint(locationLabel, toView: locationButton, multiplier: 1, constant: 20)
        
        //rightArror
        Layout().addRightConstraint(rightArror, toView: self.contentView, multiplier: 1, constant: -6)
        Layout().addWidthConstraint( rightArror, toView: nil, multiplier: 0, constant: 7)
        Layout().addHeightConstraint(rightArror, toView: nil, multiplier: 0, constant: 12)
        Layout().addCenterYConstraint(rightArror, toView: self.contentView, multiplier: 1, constant: 0)
    }
    
    let locationButton: UIButton = {
    
        var tempView = UIButton()
        tempView.titleLabel?.font = UIFont.systemFontOfSize(15)
        tempView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        tempView.setImage(UIImage(named: "home_ask_question_location"), forState: UIControlState.Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
        
    } ()
    
    let locationLabel: UILabel = {
    
        var tempView = UILabel()
        tempView.text = "正在定位"
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.userInteractionEnabled = false
        tempView.textColor = UIColor.lightGrayColor()
        tempView.textAlignment = NSTextAlignment.Right
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let rightArror: UIImageView = {
    
        var tempView = UIImageView()
        tempView.image = UIImage(named: "icon_cell_rightArrow")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
}
