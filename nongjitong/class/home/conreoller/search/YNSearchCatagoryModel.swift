//
//  YNSearchCatagoryModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/31.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSearchCatagoryModel {
    
    var cid: String?
    var name: String?
    var docs: String?
    
    init(dict: NSDictionary) {
        
       self.cid = dict["cid"] as? String
       self.name = dict["name"] as? String
       self.docs = dict["docs"] as? String
    }
    
    
    
}