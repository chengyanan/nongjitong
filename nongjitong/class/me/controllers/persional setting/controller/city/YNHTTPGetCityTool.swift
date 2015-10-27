//
//  YNHTTPGetCityTool.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/27.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpGetCityTool {
    
    //MARK: - 获取地区信息parentId为0获取省的信息
    func getAreaChildsWithParentId(parentId: String, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "edge5de7se4b5xd",
            "c": "Index",
            "a": "getAreaChilds",
            "parent_id": parentId,
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            print("data - \(json)")
            
            if let _ = successFull {
                
                successFull!(json: json)
            }
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }

    func getAreaWithId(id: String, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "edge5de7se4b5xd",
            "c": "Index",
            "a": "getArea",
            "id": id,
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            print("data - \(json)")
            
            if let _ = successFull {
                
                successFull!(json: json)
            }
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
}