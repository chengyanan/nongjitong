//
//  YNStatisticsDetailsModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/24.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNStatisticsDetailsModel {
    
    var user_name: String?
    var avatar: String?
    var value: String?
    
    init(dict: NSDictionary) {
        
        self.user_name = dict["user_name"] as? String
        self.avatar = dict["avatar"] as? String
        
//        let count = dict["value"] as! Int
        self.value = dict["value"] as? String
        
    }
    
    
}