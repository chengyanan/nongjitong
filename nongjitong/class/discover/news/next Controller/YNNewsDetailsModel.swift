//
//  YNNewsDetailsModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit


class YNNewsDetailsModel {
    
    var newsModel: YNNewsModel?
    var shareurl: String?
    var content: String?
    var contentHeight: CGFloat = 0
    
    var relation = [YNNewsModel]()
    var comments = [YNNewsCommentModel]()
    
    init(dict: NSDictionary) {
    
        self.newsModel = YNNewsModel(dict: dict)
        self.shareurl = dict["shareurl"] as? String
        self.content = dict["content"] as? String

        let tempRelationArray = dict["relation"] as? NSArray
        let tempCommentsArray = dict["comments"] as? NSArray
        
        if tempRelationArray?.count > 0 {
        
            for item in tempRelationArray! {
            
                let model = YNNewsModel(dict: item as! NSDictionary)
                self.relation.append(model)
            }
        }
        
        
        if  tempCommentsArray?.count > 0 {
            
            for var i = 0; i < tempCommentsArray?.count; i++ {
            
            
                let item = tempCommentsArray![i] as! NSDictionary
                
                let model = YNNewsCommentModel(dict: item)
                
                model.index = i
                
                self.comments.append(model)
                
            }
        

        }
        
        
        self.contentHeight = Tools().heightForText(self.content!, font: UIFont.systemFontOfSize(13), width: kScreenWidth - 24).height + 20
        
        
    }
    
    
    
    
    
    
}