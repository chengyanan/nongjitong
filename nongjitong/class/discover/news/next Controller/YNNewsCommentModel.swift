//
//  YNNewsCommentModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit


class YNNewsCommentModel {
    
    static let leftRightMargin: CGFloat = 12
    static let top: CGFloat = 10
    static let avatarHeight: CGFloat = 30
    static let avatorContentMargin: CGFloat = 10
    
    var index = 0
    
    //评论的ID
    var id: String?
    
    //评论者的ID
    var user_id: String?
    
    //评论者的名称
    var user_name: String?
    
    //头像URL
    var avatar: String?
    
    //评论内容
    var content: String?
    
    //赞成人数
    var support_num = 0
    
    //反对人数
    var oppose_num = 0
    
    //评论时间
    var add_time: String?
    
    var height: CGFloat = 0
    
    init() {}
    
    init(dict: NSDictionary) {
        
        self.id = dict["id"] as? String
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        self.avatar = dict["avatar"] as? String
        self.content = dict["content"] as? String
        self.support_num = dict["support_num"] as! Int
        self.oppose_num = dict["oppose_num"] as! Int
        self.add_time = dict["add_time"] as? String
        
        let contentHeight = Tools().heightForText(self.content!, font: UIFont.systemFontOfSize(12), width: kScreenWidth - 12*2).height
        
        self.height = 10 + 30 + 10 + contentHeight + 10
        
    }
    
    
    
    
    
}