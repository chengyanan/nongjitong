//
//  YNVoteDetailsModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/22.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation


class YNVoteDetailsModel: YNThreadModel {
    
    //属于投票项目的属性
    //所在圈子标题
    var group: String?
    //允许用户投多少项
    var user_vote_max: String?
    //结束时间
    var end_time: String?
    
    //投票项的投票统计列表
    var items = [YNVoteItem]()
    
    override init(dict: NSDictionary) {
        super.init(dict: dict)
        
        self.group = dict["group"] as? String
        self.user_vote_max = dict["user_vote_max"] as? String
        self.end_time = dict["end_time"] as? String
        
        let itemArray = dict["items"] as! NSArray
        
        for var i = 0; i < itemArray.count; i++ {
        
            let item = itemArray[i]
            
            let model = YNVoteItem(dict: item as! NSDictionary)
            
            model.index = i
            
            self.items.append(model)
        }
        
        
        
    }
    
    
    
}