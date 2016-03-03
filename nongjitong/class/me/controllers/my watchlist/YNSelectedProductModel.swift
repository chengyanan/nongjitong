//
//  YNSelectedProductModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/17.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSelectedProductModel {
    
    var class_id: String?
    var id = ""
    var user_id = ""
    var class_name = ""
    var isSelected: Bool = false

    init() {}
    
    init(id: String, name: String) {
    
        self.class_id = id
        self.id = id
        self.class_name = name
    }
    
    init(dict: NSDictionary) {
        
        self.class_id = dict["class_id"] as? String
        self.id = dict["id"] as! String
        self.class_name = dict["class_name"] as! String
        self.user_id = dict["user_id"] as! String
        
    }
   
    
    
}