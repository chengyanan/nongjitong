//
//  YNQuestionModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/30.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNQuestionModel {
    
    var marginModel = YNQuestionModelConstant()
    
    //问题的ID
    var id = ""
    
    //提问者ID
    var user_id = ""
    
    //提问者名称
    var user_name = ""
    
    //问题的描述
    var descript = ""
    
    //所属分类ID
    var class_id = ""
    
    //所属分类
    var class_name = ""
    
    //提问时间
    var add_time = ""
    
    //存放图片的数组
    var photo = [String]()
    
    //问题的状态。1 待回答,2 线上采纳,3 线下解决,4 问题超时
    var status = ""
    
    var height: CGFloat?
    
    init() {}
    
    init(dict: NSDictionary) {
        
        if let _ = dict["id"] as? String {
        
            self.id = dict["id"] as! String
        }
        
        if let _ = dict["user_id"] as? String {
        
            self.user_id = dict["user_id"] as! String
        }
        
        
        self.user_name = dict["user_name"] as! String
        
        self.descript = dict["descript"] as! String
        self.class_id = dict["class_id"] as! String
        self.add_time = dict["add_time"] as! String
        self.status = dict["status"] as! String
        
        if let _ = dict["class_name"] as? String {
        
            self.class_name = dict["class_name"] as! String
        }
        
        self.photo = dict["photo"] as! Array<String>
        
        calcuateCellHeight(self.descript)
    }
    
    func calcuateCellHeight(text: String) {
        
        let contentWidth = kScreenWidth - marginModel.leftRightMargin*2
        
        let contentHeight = heightForText(text, font: UIFont.systemFontOfSize(15), width: contentWidth)
        
        var height = marginModel.topMargin + marginModel.avatarHeight + marginModel.marginBetweenAvatarAndDescription + contentHeight
        
        marginModel.imageY = height + marginModel.marginBetweenDescriptionAndImages
        
        if self.photo.count > 0 {
            
            let imageWidthHeight = (kScreenWidth - marginModel.leftRightMargin*2 -  CGFloat(self.photo.count - 1) * marginModel.imageMargin ) / 3 - 1
            marginModel.imageWidthHeight = imageWidthHeight
        
            height += marginModel.marginBetweenDescriptionAndImages + marginModel.imageWidthHeight!
            
        } else {
        
            marginModel.imageWidthHeight = (kScreenWidth - marginModel.leftRightMargin*2) / 3 - 1
        }
        
        self.height = height + 10
        
    }
    
    func heightForText(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 3
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}