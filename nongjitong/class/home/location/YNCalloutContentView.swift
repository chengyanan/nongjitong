//
//  YNCalloutContentView.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/21.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import UIKit

class YNCalloutContentView: UIView {

    lazy var imageView:UIImageView = {
        var tempImageView = UIImageView()
        tempImageView.clipsToBounds = true
        tempImageView.layer.cornerRadius = 20
        return tempImageView
        }()
    lazy var titleLabel:UILabel = {
        var tempLabel = UILabel()
//        tempLabel.backgroundColor = UIColor.whiteColor()//防止文字重叠
        tempLabel.font = UIFont.systemFontOfSize(14)
        
        tempLabel.adjustsFontSizeToFitWidth = true
        
        return tempLabel
        }()
    lazy var subTitleLabel:UILabel = {
        var tempLabel = UILabel()
        //        tempLabel.backgroundColor = UIColor.whiteColor()//防止文字重叠
        tempLabel.font = UIFont.systemFontOfSize(13)
        tempLabel.adjustsFontSizeToFitWidth = true
        return tempLabel
    }()
    
    var dataModel: YNNearByModel? {
  
        willSet {
       
            self.titleLabel.text = ""
            self.subTitleLabel.text = ""
        }
        
        didSet {
       
            if let _ = dataModel {
            
                if let tempImage = dataModel?.avatar {
                    
                    self.imageView.getImageWithURL(tempImage, contentMode: UIViewContentMode.ScaleAspectFill)
                }
                
                titleLabel.text = dataModel!.user_name!
                
                if let _ = dataModel!.role   {
                    
                    self.subTitleLabel.text = "\(dataModel!.role!)"
                
                    if let _ = dataModel!.range {
                        
                        self.subTitleLabel.text = "\(dataModel!.role!) \(dataModel!.range!)m"
                    }
                }
                
                
                
                
            }
    
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        //imageView
        let imageViewX: CGFloat = 6
        let imageViewW: CGFloat = 40
        let imageViewH: CGFloat = imageViewW
        let imageViewY: CGFloat = (frame.size.height - imageViewH) * 0.5
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)
        
        //titleLabel
        let span: CGFloat = 6
        let titleX: CGFloat = CGRectGetMaxX(imageView.frame) + span
        let titleH: CGFloat = frame.size.height * 0.3
        titleLabel.frame = CGRectMake(titleX, 10, frame.size.width - titleX - 6, titleH)
        
        //subTitleLabel
        let subTitleY = CGRectGetMaxY(titleLabel.frame) + 3
        subTitleLabel.frame = CGRectMake(titleX, subTitleY, frame.size.width - titleX - 6, titleH)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
