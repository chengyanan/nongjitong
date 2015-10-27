//
//  YNBaseCityModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/27.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNBaseCityModel {
    
    var parent_id = ""
    var id = ""
    var city_name = ""
    
    init() {}
    
    init(dict: NSDictionary) {
    
        self.parent_id = dict["parent_id"] as! String
        self.id = dict["id"] as! String
        self.city_name = dict["city_name"] as! String
        
    }
}