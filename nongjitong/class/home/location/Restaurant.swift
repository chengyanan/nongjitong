//
//  Restaurant.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/21.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant {
    
    let id: Double?
    let level: Int?
    let range: Int?
    
    let address: String?
    let image: String?
    let coordinate: CLLocationCoordinate2D?
    let summary: String?
    let telphone: String?
    let title: String?
    
    //TODO:公告
    let announcement: String?
    
    init(dict : NSDictionary) {
   
        id = dict["id"] as? Double
        level = dict["level"] as? Int
        range = dict["range"] as? Int
        address = dict["address"] as? String
        image = dict["image"] as? String
        
        summary = dict["summary"] as? String
        telphone = dict["telphone"] as? String
        title = dict["title"] as? String
        announcement = "满50减5, 满100减15"
        
        
        let point = dict["point"] as? NSString
        let arrayStr: Array<String>? = point!.componentsSeparatedByString(",")
        
        var longitude: CLLocationDegrees = 0
        var latitude: CLLocationDegrees = 0
        
        if let lon = arrayStr?[0]{
       
            longitude = Double(lon)!
        }
        
        if let lat = arrayStr?[1] {
            
            latitude = Double(lat)!
        }
        
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    
}