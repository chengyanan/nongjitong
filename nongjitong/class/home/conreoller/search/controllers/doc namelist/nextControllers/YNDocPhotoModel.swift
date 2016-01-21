//
//  YNDocPhotoModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/21.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation

class Photo {
    
    var title: String?
    var url: String?
    
    var index: Int?
    
    var totalCount: Int?
    
    
    init(title: String?, url: String?, index: Int) {
    
        self.title = title
        self.url = url
        self.index = index
    }
    
    
}