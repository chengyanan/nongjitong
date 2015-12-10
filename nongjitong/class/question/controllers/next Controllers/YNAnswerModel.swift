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
    
    var contentSize: CGSize {
        
        let width = kScreenWidth - marginTopBottomLeftOrRight - avatarWidthHeight - marginBetweenAvatarAndContent - marginContent
        
        let size = Tools().heightForText(self.description!, font: UIFont.systemFontOfSize(15), width: width)
        
        let secondsize = Tools().heightForText(self.description!, font: UIFont.systemFontOfSize(15), width: width - 40)
        
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
    
    var avatarUrl: String?
    var username: String?
    var description: String?
    
    var questionId: String?

    var isQuestionOwner: Bool?
    
    var isFinish: Bool = true
    
    var cellHeight: CGFloat?
    
    init(){}
    
    init(dict: NSDictionary) {
    
        self.avatarUrl = dict["avatarUrl"] as? String
        self.username = dict["username"] as? String
        self.description = dict["descriptiom"] as? String
        self.isQuestionOwner = dict["isQuestionOwner"] as? Bool
        
        //头像的高度
        let avatarheight = avatarWidthHeight + marginTopBottomLeftOrRight*2
        
        //文字的高度
        let contentHeight = self.contentSize.height + marginTopBottomLeftOrRight*2
        
        if avatarheight > contentHeight {
            
            self.cellHeight = avatarheight
            
        } else {
            
            self.cellHeight = contentHeight
        }
        
    }

    
}