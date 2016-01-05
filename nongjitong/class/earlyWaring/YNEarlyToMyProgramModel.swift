//
//  YNEarlyToMyProgramModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNEarlyToMyProgramModel {
    
     var marginModel = YNQuestionModelConstant()
    
    var id: String?
    var user_id: String?
    var user_name: String?
    var summary: String?
    var content: String?
    var read_num: String?
    var add_time: String?
    var subscribe = [YNSubscribeModel]()
    var photos = [String]()
    
    //cell高度
    var summaryHeight:  CGFloat?
    
    var contentHeight: CGFloat?
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as? String
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        self.summary = dict["summary"] as? String
        self.read_num = dict["read_num"] as? String
        self.add_time = dict["add_time"] as? String
        self.content = dict["content"] as? String
        
        let tempArray = dict["subscribe"] as? NSArray
        
        if let _ = tempArray {
            
            ////subscribe是数组
        
            for item in tempArray! {
                
                let dict = item as? NSDictionary
                
                let model = YNSubscribeModel(dict: dict!)
                
                self.subscribe.append(model)
            }
            
        } else {
        
            //subscribe是字典
            let tempDic = dict["subscribe"] as? NSDictionary
            let model = YNSubscribeModel(dict: tempDic!)
            self.subscribe.append(model)
            
        }
        
        
       
        
        let tempPhotoArray = dict[photos] as? NSArray
        
        if let _ = tempPhotoArray {
        
            for item in tempPhotoArray! {
                
                let str = item as? String
                
                self.photos.append(str!)
            }
        }
        
        if let _ = self.summary {
        
            self.calcuateCellHeight(self.summary!)
        }
        
        if let _  = self.content {
        
            self.calcuateCellHeight(self.content!)
        }
        
    }

    
    func calcuateCellHeight(text: String) {
        
        let contentWidth = kScreenWidth - marginModel.leftRightMargin*2
        
        if let _ = self.summary {
        
            let contentHeight = heightForText(text, font: UIFont.systemFontOfSize(15), width: contentWidth, lines: 3)
            self.summaryHeight = marginModel.topMargin*2 + contentHeight + marginModel.answerCountHeight
        }
        
        if let _ = self.content {
        
            let allContentHeight = heightForText(text, font: UIFont.systemFontOfSize(15), width: contentWidth, lines: 0)
            self.contentHeight = marginModel.topMargin*2 + allContentHeight + marginModel.answerCountHeight
        }
        
    }
    
    //计算label的高度
    func heightForText(text:String, font:UIFont, width:CGFloat, lines: Int) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = lines
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
}