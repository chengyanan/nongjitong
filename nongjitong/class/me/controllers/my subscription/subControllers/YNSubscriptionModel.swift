//
//  YNSubscriptionModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSubscriptionModel {
    
    var product_name = ""
    var area_id = ""
    var range = ""
    var address = ""
    
    init() {}
    
    init(dict: NSDictionary) {
        
        self.product_name = dict["class_id"] as! String
        self.area_id = dict["id"] as! String
        self.range = dict["class_name"] as! String
        
    }
    
    
    
}