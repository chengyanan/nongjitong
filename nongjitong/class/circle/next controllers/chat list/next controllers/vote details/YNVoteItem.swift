//
//  YNVoteItem.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/22.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation

class YNVoteItem {
    
    var id: String?
    var item_id: String?
    var title: String?
    var value: String?
    var index: Int?
    var isSelected = false
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as? String
        self.item_id = dict["item_id"] as? String
        self.title = dict["title"] as? String
        
        let count = dict["value"] as! Int
        
        self.value = "\(count)"
        
    }
    
    
    
}