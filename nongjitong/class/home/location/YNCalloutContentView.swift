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
        tempImageView.contentMode = UIViewContentMode.ScaleToFill
        return tempImageView
        }()
    lazy var titleLabel:UILabel = {
        var tempLabel = UILabel()
//        tempLabel.backgroundColor = UIColor.whiteColor()//防止文字重叠
        tempLabel.font = UIFont.systemFontOfSize(14)
        return tempLabel
        }()
    
    var dataModel: Restaurant? {
  
        willSet {
       
            self.titleLabel.text = ""
        }
        
        didSet {
       
            if let tempImage = dataModel?.image {
                
                Network.getImageWithURL(tempImage, success: { (data) -> Void in
                    
                    self.imageView.image = UIImage(data: data)
                    
                })
                
                
            }
        
            titleLabel.text = dataModel?.title
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        let imageViewX: CGFloat = 6
        let imageViewY: CGFloat = 6
        let imageViewW: CGFloat = 50
        let imageViewH: CGFloat = imageViewW
        let span: CGFloat = 2
        let titleX: CGFloat = imageViewX + imageViewW + span
        let titleH: CGFloat = imageViewW * 0.6
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)
        
        titleLabel.frame = CGRectMake(titleX, imageViewY, frame.size.width - titleX - 1, titleH)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
