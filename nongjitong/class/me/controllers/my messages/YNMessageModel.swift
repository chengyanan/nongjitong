//
//  YNMessageModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNMessageModel {
    
    var id: String?
    var user_id: String?
    var to_user_id: String?
    var content: String?
    var group_id: String?
    var status: String?
    var add_time: String?
    var cellheight: CGFloat?
    
    init(dict: NSDictionary) {
        
        self.id = dict["id"] as? String
        self.user_id = dict["user_id"] as? String
        self.to_user_id = dict["to_user_id"] as? String
        self.content = dict["content"] as? String
        self.group_id = dict["group_id"] as? String
        self.status = dict["status"] as? String
        self.add_time = dict["add_time"] as? String
        
        let contentHeight = Tools().heightForText(self.content!, font: UIFont.systemFontOfSize(13), width: kScreenWidth - 24).height
        
        self.cellheight = contentHeight + 30
        
    }
    
    
    
    
    
}