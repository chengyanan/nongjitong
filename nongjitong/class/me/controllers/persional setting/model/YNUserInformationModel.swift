//
//  YNUserInformationModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/27.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNUserInformationModel {
    
    var id = ""
    var comm_id = ""
    var nickname = ""
    var mobile = ""
    var area_id = ""
    var role = ""
    var truename: String?
    var sex: String?
    var id_num: String?
    var address: String?
    
    init(dict: NSDictionary) {
    
        self.id = dict["id"] as! String
        self.comm_id = dict["comm_id"] as! String
        self.nickname = dict["nickname"] as! String
        self.mobile = dict["mobile"] as! String
        self.area_id = dict["area_id"] as! String
        self.role = dict["role"] as! String
        
        self.truename = dict["truename"] as? String
        self.sex = dict["sex"] as? String
        self.id_num = dict["id_num"] as? String
        self.address = dict["address"] as? String
        
    }
    
}