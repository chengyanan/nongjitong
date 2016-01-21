//
//  YNDocAlbumCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocAlbumCollectionViewCell: UICollectionViewCell {

    var photo: Photo? {
    
        didSet {
        
            imageTitle.text = "   \(photo!.title!)"
            self.imageView.getImageWithURL(photo!.url!, contentMode: UIViewContentMode.ScaleToFill)
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
        tempView.contentMode = .ScaleToFill
        tempView.image = UIImage(named: "user_default_avatar")
        tempView.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(imageTitle)
        
        Layout().addTopBottomConstraints(imageView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(imageView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(imageView, toView: contentView, multiplier: 1, constant: 0)
        
        Layout().addBottomConstraint(imageTitle, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(imageTitle, toView: contentView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(imageTitle, toView: nil, multiplier: 0, constant: 20)
        Layout().addWidthConstraint(imageTitle, toView: contentView, multiplier: 1, constant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
}
