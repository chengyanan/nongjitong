//
//  YNCityModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNCityModel: YNBaseModel {
    
    var array: Array<YNBaseModel> = Array()
    
    override init(dict: NSDictionary) {
        super.init(dict: dict)
        
        let tempArray: NSArray = dict["list"] as! NSArray
        
        for item in tempArray {
        
            let tempItem = item as! NSDictionary
            
            let basemodel = YNBaseModel(dict: tempItem)
            
            self.array.append(basemodel)
        }
        
        
    }
    
    override init() {
        super.init()
        
    
    }
}