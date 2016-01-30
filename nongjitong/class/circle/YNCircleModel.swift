//
//  YNCircleModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNCircleModel {
    
    var id: String?
    var user_id: String?
    var title: String?
    var announcement: String?
    var announcementHeight: CGFloat = 44
    
    var add_time: String?
    var photo = [String]()
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as? String
        self.user_id = dict["user_id"] as? String
        self.title = dict["title"] as? String
        self.announcement = dict["announcement"] as? String
        self.add_time = dict["add_time"] as? String
        
        let size = Tools().heightForText(self.announcement!, font: UIFont.systemFontOfSize(13), width: kScreenWidth - 24)
        
        self.announcementHeight = size.height + 30
        
        if self.announcementHeight < 44 {
        
            self.announcementHeight = 44
        }
        
        
    }
    
    
    
    
}