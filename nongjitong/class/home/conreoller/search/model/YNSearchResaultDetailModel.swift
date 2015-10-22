//
//  YNSearchResaultDetailModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/22.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSearchResaultDetailModel: YNSearchResaultModel {
    
    var content = ""
    
    override init(dict: NSDictionary) {
        super.init(dict: dict)
        
        self.content = dict["content"] as! String
        
    }
    
}