//
//  YNAskQuestionModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/17.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNAskQuestionModel {

    //用户id
    var user_id: String? {
        
        return kUser_ID() as? String
    }
    //问题描述
    var descript: String?
    //	问题的领域ID
    var class_id: String?
    
    //纬度
    var latitude: String?
    
    //精度
    var longitude: String?
    
    //详细地址
    var address_detail: String?
    
    //到县的地址
    var address: String?
    
    init() {}
}