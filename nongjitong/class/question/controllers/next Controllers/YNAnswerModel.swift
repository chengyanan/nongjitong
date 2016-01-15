//
//  YNAnswerModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNAnswerModel {
    
    let avatarWidthHeight: CGFloat = 30
    let marginTopBottomLeftOrRight: CGFloat = 8
    let marginBetweenAvatarAndContent: CGFloat = 3
    let marginContent:CGFloat = 20
    
    var contentRealSize: CGSize {
    
        let width = kScreenWidth - marginTopBottomLeftOrRight * 2
        
        let size = Tools().heightForText(self.content!, font: UIFont.systemFontOfSize(15), width: width)
        
        return CGSizeMake(width, size.height + 12)
    }
    
    var contentSize: CGSize {
        
        let width = kScreenWidth - marginTopBottomLeftOrRight - avatarWidthHeight - marginBetweenAvatarAndContent - marginContent
        
        let size = Tools().heightForText(self.content!, font: UIFont.systemFontOfSize(15), width: width)
        
        let secondsize = Tools().heightForText(self.content!, font: UIFont.systemFontOfSize(15), width: width - 40)
        
        var realSize = CGSizeZero
        
        if size.width == secondsize.width && size.height == secondsize.height {
        
            //单行
            realSize = size
            realSize.width += 41
            realSize.height += 26
            
        } else {
        
            //多行
            realSize = CGSize(width: size.width, height: secondsize.height + 30)
        }
        
        return realSize
    }
    
    var user_id: String?
    var user_name: String?
    var avatar: String?
    var content: String?
    var questionId: String?
    var add_time: String?
    var to_user_id: String?
    var is_accept: String?
    
    var isQuestionOwner: Bool?
    
    var isFinish: Bool = true
    
    var cellHeight: CGFloat?
    
    init(){}
    
    init(dict: NSDictionary) {
    
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        self.avatar = dict["avatar"] as? String
        self.content = dict["content"] as? String
        self.add_time = dict["add_time"] as? String
        self.to_user_id = dict["to_user_id"] as? String
        self.is_accept = dict["is_accept"] as? String
        
        
        //头像的高度
        let avatarheight = avatarWidthHeight + marginTopBottomLeftOrRight*2
        
        if let _ = self.content {
        
            //文字的高度
            let contentHeight = self.contentSize.height + marginTopBottomLeftOrRight*2
            
            if avatarheight > contentHeight {
                
                self.cellHeight = avatarheight
                
            } else {
                
                self.cellHeight = contentHeight
            }
            
        } else {
        
            self.cellHeight = avatarheight
//            print("回答的 content 为nil")
        }
        
        
        
    }

    
}