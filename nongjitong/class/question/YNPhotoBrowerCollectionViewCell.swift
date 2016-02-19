//
//  YNPhotoBrowerCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/19.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNPhotoBrowerCollectionViewCell: UICollectionViewCell {

    
    var photo: Photo? {
        
        didSet {
            
            self.imageView.getImageWithURL(photo!.url!, contentMode: UIViewContentMode.ScaleAspectFit)
            self.imageView.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    
    //    var imageUrl: String? {
    //
    //        didSet {
    //
    //            self.imageView.getImageWithURL(imageUrl!, contentMode: UIViewContentMode.ScaleToFill)
    //        }
    //    }
    
    
    let imageView: UIImageView = {
        
        let tempView = UIImageView()
        tempView.contentMode = .ScaleAspectFit
        tempView.image = UIImage(named: "user_default_avatar")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        return tempView
        
    }()
    
    var imageTitle: UILabel = {
        
        let tempView = UILabel()
        
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        tempView.textColor = UIColor.whiteColor()
        return tempView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
//        contentView.addSubview(imageTitle)
        
        Layout().addTopConstraint(imageView, toView: contentView, multiplier: 1, constant: 20)
        Layout().addBottomConstraint(imageView, toView: contentView, multiplier: 1, constant: -20)
            
        Layout().addLeftConstraint(imageView, toView: contentView, multiplier: 1, constant: 10)
        Layout().addRightConstraint(imageView, toView: contentView, multiplier: 1, constant: -10)
        
//        Layout().addBottomConstraint(imageTitle, toView: contentView, multiplier: 1, constant: 0)
//        Layout().addLeftConstraint(imageTitle, toView: contentView, multiplier: 1, constant: 0)
//        Layout().addHeightConstraint(imageTitle, toView: nil, multiplier: 0, constant: 20)
//        Layout().addWidthConstraint(imageTitle, toView: contentView, multiplier: 1, constant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
