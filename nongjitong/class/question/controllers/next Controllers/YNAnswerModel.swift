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
    let margin: CGFloat = 8
    
    var contentSize: CGSize {
        
        let width = kScreenWidth - margin*3 - avatarWidthHeight
        
        var size = Tools().heightForText(self.description!, font: UIFont.systemFontOfSize(15), width: width)
        
        if size.width + 5 >= width {
        
            size.height += 44
            
        } else {
        
            size.height += 20
            size.width += 40
        }
        
        return size
    }
    
    var avatarUrl: String?
    var username: String?
    var description: String?

    var isQuestionOwner: Bool?
    
    
    var cellHeight: CGFloat?
    
    init(){}
    
    init(dict: NSDictionary) {
    
        self.avatarUrl = dict["avatarUrl"] as? String
        self.username = dict["username"] as? String
        self.description = dict["descriptiom"] as? String
        self.isQuestionOwner = dict["isQuestionOwner"] as? Bool
        
        //头像的高度
        let avatarheight = avatarWidthHeight + margin*2
        
        //文字的高度
        let contentHeight = self.contentSize.height + margin*2
        
        if avatarheight > contentHeight {
            
            self.cellHeight = avatarheight
            
        } else {
            
            self.cellHeight = contentHeight
        }
        
    }
    
    
    
}