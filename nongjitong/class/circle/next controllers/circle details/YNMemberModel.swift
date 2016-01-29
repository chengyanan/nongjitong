//
//  YNMemberModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/29.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation

class YNMemberModel {
    
    var user_id: String?
    var user_name: String?
    var is_master: String?
    var master_vote_user: String?
    var delete_vote: String?
    var avatar: String?
    
    init(dict: NSDictionary) {
        
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        self.is_master = dict["is_master"] as? String
        self.master_vote_user = dict["master_vote_user"] as? String
        self.delete_vote = dict["delete_vote"] as? String
        self.avatar = dict["avatar"] as? String
        
    }
    
    
    
}