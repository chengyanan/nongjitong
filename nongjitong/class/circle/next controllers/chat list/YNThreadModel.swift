//
//  YNThreadModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/16.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNThreadModel {
    
    var marginModel = YNQuestionModelConstant()
    
    //公告的ID
    var id: String?
    
    //圈子的ID
    var group_id: String?
    
    //用户的ID
    var user_id: String?
    
    //用户的名称
    var user_name: String?
    
    //用户图像地址
    var avatar: String?
    
    //公告标题
    var title: String?
    
    //公告内容摘要
    var descript: String?
    
    //发布时间
    var add_time: String?
    
    //显示的时间
    var createTime: String?
    
    //存放图片的数组
    var photo = [String]()
    
    //消息的类型: "1"=>通知,"2"=>"销售","3"=>"采购","4"=>"分成","5"=>"台帐","6"=>"意见"
    var type: String?
    
    var height: CGFloat?
    
    var titleHeight: CGFloat?
    var contentHeight: CGFloat?
    
    init() {}
    
    init(dict: NSDictionary) {
        
        self.id = dict["id"] as? String
        self.group_id = dict["group_id"] as? String
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        
        
        if dict["avatar"] as? String == "" {
            
            //没有头像
            self.avatar = nil
        } else {
            
            self.avatar = dict["avatar"] as? String
        }
        
       
        if dict["user_name"] as! String == "" {
            
            self.user_name = "没有昵称"
            
        } else {
            
            self.user_name = dict["user_name"] as? String
            
        }
        
        
        self.title = dict["title"] as? String
        self.descript = dict["descript"] as? String
        
        self.titleHeight = Tools().heightForText(self.title!, font: UIFont.systemFontOfSize(15), width: kScreenWidth - 24).height + 30
        self.contentHeight = Tools().heightForText(self.descript!, font: UIFont.systemFontOfSize(15), width: kScreenWidth - 24).height + 30
    
        self.add_time = dict["add_time"] as? String
//        self.createTime = calcuateTime(self.add_time!)
        
        if let _ = dict["photo"] as? Array<String> {
        
            self.photo = dict["photo"] as! Array<String>
        }
     
        self.type = dict["type"] as? String
        
        calcuateCellHeight(self.descript!)
        
    }
    
    func calcuateTime(time: String) ->String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        let createTime = dateFormatter.dateFromString(time)
        
        if createTime!.isToday() {
            
            if createTime?.deltaWithNow().hour >= 1 {
                
                return "\(createTime!.deltaWithNow().hour)小时前"
                
            } else if createTime?.deltaWithNow().minute >= 1 {
                
                return "\(createTime!.deltaWithNow().minute)分钟前"
                
            } else {
                
                return "刚刚"
            }
            
        } else if createTime!.isYesterday() {
            
            dateFormatter.dateFormat = "昨天 HH:MM"
            
            return dateFormatter.stringFromDate(createTime!)
            
        } else if createTime!.isThisYear() {
            
            dateFormatter.dateFormat = "MM-dd HH:mm"
            
            return dateFormatter.stringFromDate(createTime!)
            
        } else {
            
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
            
            return dateFormatter.stringFromDate(createTime!)
        }
        
        
    }
    
    func calcuateCellHeight(text: String) {
        
        let contentWidth = kScreenWidth - marginModel.leftRightMargin*2
        
        let contentHeight = heightForText(text, font: UIFont.systemFontOfSize(15), width: contentWidth)
        
        var height = marginModel.topMargin + marginModel.avatarHeight + marginModel.marginBetweenAvatarAndDescription + contentHeight
        
        marginModel.imageY = height + marginModel.marginBetweenDescriptionAndImages
        
        if self.photo.count > 0 {
            
            var imageWidthHeight: CGFloat = 0
            
            let photoAiiWidth = kScreenWidth - marginModel.leftRightMargin*2
            
            var marginAllWidth: CGFloat = 0
            
            //MARK: 图片最大数量为3
            if self.photo.count < 3 {
                
                marginAllWidth = CGFloat(self.photo.count - 1) * marginModel.imageMargin
                
            } else {
                
                marginAllWidth = 2*marginModel.imageMargin
                
            }
            
            imageWidthHeight = (photoAiiWidth - marginAllWidth) / 3 - 1
            
            marginModel.imageWidthHeight = imageWidthHeight
            
            height += marginModel.marginBetweenDescriptionAndImages + marginModel.imageWidthHeight!
            
        } else {
            
            //没有图片
            
            
        }
        
        self.height = height + 16
        
    }
    
    //计算label的高度
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