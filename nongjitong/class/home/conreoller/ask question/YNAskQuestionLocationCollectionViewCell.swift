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

    //MARK: public proporty
    var coorinate: CLLocationCoordinate2D? {
    
        didSet {
        
            if coorinate != nil {
            
                //解析地址
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (coorinate?.latitude)!, longitude: (coorinate?.longitude)!)) { (placemarks, error) -> Void in
                    
                    if let _ = placemarks {
                        
                        let placeMark: CLPlacemark = placemarks!.first!
                        
                        if let thoroughfare = placeMark.thoroughfare {
                            
                            var title: String = thoroughfare
                            
                            if let subThoroughfare = placeMark.subThoroughfare {
                                
                                title += subThoroughfare
                            }
                            
                            
                            self.locationLabel.text = title
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(locationButton)
        self.contentView.addSubview(locationLabel)
        
        setLayout()
    
        
        NSNotificationCenter.defaultCenter()
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
        Layout().addRightConstraint(locationLabel, toView: self.contentView, multiplier: 1, constant: -12)
        Layout().addLeftToRightConstraint(locationLabel, toView: locationButton, multiplier: 1, constant: 20)
    }
    
    let locationButton: UIButton = {
    
        var tempView = UIButton()
        tempView.titleLabel?.font = UIFont.systemFontOfSize(15)
        tempView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tempView.setTitle("当前地址", forState: UIControlState.Normal)
        tempView.setImage(UIImage(named: "home_ask_question_location"), forState: UIControlState.Normal)
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
    

    
}
