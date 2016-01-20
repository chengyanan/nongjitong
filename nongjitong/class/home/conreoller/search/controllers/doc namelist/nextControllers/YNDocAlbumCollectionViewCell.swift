//
//  YNDocAlbumCollectionViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocAlbumCollectionViewCell: UICollectionViewCell {

    var imageUrl: String? {
    
        didSet {
        
            self.imageView.getImageWithURL(imageUrl!, contentMode: UIViewContentMode.ScaleToFill)
        }
    }
    
    
    let imageView: UIImageView = {
    
        let tempView = UIImageView()
        tempView.contentMode = .ScaleToFill
        tempView.image = UIImage(named: "user_default_avatar")
        return tempView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      contentView.addSubview(imageView)
      
        imageView.frame = self.contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
