//
//  YNSearchSolutionListModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNSearchSolutionListModel {
    
    var marginModel = YNQuestionModelConstant()
    
    //方案的ID
    var id: String?
    
    //文档的ID
    var doc_id: String?
    
    //文档的标题
    var doc_title: String?
    
    //方案的标题
    var title: String?
    
    //方案作者ID
    var user_id: String?
    
    //方案的推荐级别
    var recommend: String?
    
    //方案的阅读次数
    var read_num: String?
    
    //方案的创建时间
    var add_time: String?
    
    //方案的摘要
    var summary: String?
    
    var content: String?
    
    //方案的配图,数组类型
    var photos: Array<String>?
    
    //cell高度
    var height:  CGFloat?
    
    init(dict: NSDictionary) {
        
        self.id = dict["id"] as? String
        self.doc_id = dict["doc_id"] as? String
        self.doc_title = dict["doc_title"] as? String
        
        self.title = dict["title"] as? String
        self.user_id = dict["user_id"] as? String
        self.recommend = dict["recommend"] as? String
        
        self.read_num = dict["read_num"] as? String
        
        self.add_time = dict["add_time"] as? String
        self.photos = dict["photos"] as? Array
        
        
        if let _ = dict["summary"] as? String {
        
            self.summary = dict["summary"] as? String
           calcuateCellHeight(self.summary!)
        }
        
        if let _ = dict["content"] as? String {
        
            self.content = dict["content"] as? String
            calcuateCellHeight(self.content!)
        }
        
        
        
        
    }
    
    
    func calcuateCellHeight(text: String) {
        
        let contentWidth = kScreenWidth - marginModel.leftRightMargin*2
        
        let contentHeight = heightForText(text, font: UIFont.systemFontOfSize(15), width: contentWidth)
        
    
        self.height = marginModel.topMargin*2 + contentHeight + marginModel.answerCountHeight
    }
    
    //计算label的高度
    func heightForText(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
}