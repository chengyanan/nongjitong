//
//  YNSearchResaultDetailModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/22.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNSearchResaultDetailModel: YNSearchResaultModel {
    
    var content = ""
    var photos = [Photo]()
    override init(dict: NSDictionary) {
        super.init(dict: dict)
        
        self.content = dict["content"] as! String
        
        //解析photo
        let tempArray = dict["photos"] as? NSArray
        
        if tempArray?.count > 0 {
        
            var index = 0
            
            for item in tempArray! {
            
//                let itemTitle = item["title"] as? String
                
                let photoArray = item["images"] as? NSArray
                
                if photoArray?.count > 0 {
                
                    for photoitem in photoArray! {
                    
                        let dict = photoitem as? NSDictionary
                        
                        let itemTitle = dict!["title"] as? String
                        
                        let tempurl = dict!["url"] as? String
                        
                        let photo = Photo(title: itemTitle, url: tempurl, index: index)
                        
                        self.photos.append(photo)
                        
                        index++
                        
                    }
                }
                
            }
            
           
            if self.photos.count > 0 {
            
                for item in self.photos {
                
                    item.totalCount = index
                }
            }
            
            
        }
        
        
        
    }
    
}