//
//  YNSubscribeModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation

class YNSubscribeModel {
    
    var id: String?
    var class_name: String?
    var city_name: String?
    var range: String?
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as? String
        self.class_name = dict["class_name"] as? String
        self.city_name = dict["city_name"] as? String
        self.range = dict["range"] as? String
        
    }
    
}