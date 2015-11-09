//
//  YNCategoeyModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/9.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNCategoryModel {
    
    var parent_id = ""
    var id = ""
    var class_name = ""
    var isSelected: Bool = false
    
    init() {}
    
    init(dict: NSDictionary) {
        
        self.parent_id = dict["parent_id"] as! String
        self.id = dict["id"] as! String
        self.class_name = dict["class_name"] as! String
        
    }
}