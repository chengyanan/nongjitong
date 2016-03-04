//
//  YNMewsModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/3.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation

class YNNewsModel {
    
    var id: String?
    var title: String?
    var summary: String?
    var tags: String?
    var tagsArray = [String]?()
    var photo: String?
    var user_id: String?
    var user_name: String?
    var class_id: String?
    var class_name: String?
    var source: String?
    var order_num: String?
    var level: String?
    var add_time: String?

    init(dict: NSDictionary) {
    
        self.id = dict["id"] as? String
        self.title = dict["title"] as? String
        self.summary = dict["summary"] as? String
        self.tags = dict["tags"] as? String
        self.photo = dict["photo"] as? String
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        self.class_id = dict["class_id"] as? String
        self.class_name = dict["class_name"] as? String
        self.source = dict["source"] as? String
        self.order_num = dict["order_num"] as? String
        self.level = dict["level"] as? String
        self.add_time = dict["add_time"] as? String
        self.level = dict["level"] as? String
        self.add_time = dict["add_time"] as? String
        
        self.tagsArray = self.tags?.componentsSeparatedByString("|")
        
      
    }
    
    
    
    
}