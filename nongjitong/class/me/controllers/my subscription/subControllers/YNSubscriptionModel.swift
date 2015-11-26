//
//  YNSubscriptionModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/19.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSubscriptionModel {
    
    var class_name = ""
    var class_id = ""
    var range = ""
    var area_id = ""
    var address = ""
    var id = ""
    var user_id = ""
    
    init() {}
    
    init(dict: NSDictionary) {
        
        self.class_name = dict["class_name"] as! String
        
        self.class_id = dict["class_id"] as! String

        self.range = dict["range"] as! String
        
        self.area_id = dict["area_id"] as! String
        
        self.address = dict["address"] as! String
        
        self.id = dict["id"] as! String
        
        self.user_id = dict["user_id"] as! String
    
    }
    
    
    
}