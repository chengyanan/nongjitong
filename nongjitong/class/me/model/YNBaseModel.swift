//
//  YNBaseModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNBaseModel {
    
    var id = ""
    var name = ""
    
    init() {
    
    }
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as! String
        self.name = dict["name"] as! String
    }
}