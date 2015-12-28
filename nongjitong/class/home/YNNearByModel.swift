//
//  YNNearByModel.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/24.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation
import CoreLocation

class YNNearByModel {
    
    var user_id: String?
    var user_name: String?
    var latitude: String?
    var longitude: String?
    var range: Int?
    var avatar: String?
    var role: String?
    
    var area: String?
    var mobile: String?
    
    var coordinate: CLLocationCoordinate2D?
    
    
    init() {
        
    }
    
    init(dict: NSDictionary) {
        
        self.user_id = dict["user_id"] as? String
        self.user_name = dict["user_name"] as? String
        self.latitude = dict["latitude"] as? String
        self.longitude = dict["longitude"] as? String
        self.range = dict["range"] as? Int
        self.avatar = dict["avatar"] as? String
        self.role = dict["role"] as? String
        
        self.area = dict["area"] as? String
        self.mobile = dict["mobile"] as? String
        
        self.coordinate = CLLocationCoordinate2DMake(Double(self.latitude!)!, Double(self.longitude!)!)

    }
    
    
}