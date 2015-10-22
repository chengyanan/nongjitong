//
//  YNSearchResaultModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/21.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSearchResaultModel {
    
    //文章id
    var id = ""
    //标题
    var title = ""
    //摘要
    var summary = ""
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as! String
        self.title = dict["title"] as! String
        self.summary = dict["summary"] as! String
    }


}