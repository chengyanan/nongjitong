//
//  YNWatchHttp.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/17.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNWatchHttp {
    
    class func getUserSpecialty(successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "getUserSpecialty",
            "user_id": userId,
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
//            print("data - \(json)")
            
            if let _ = successFull {
                
                successFull!(json: json)
            }
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
    class func updateQusetionClassWithClassId(classId: String, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "updateQusetionClass",
            "user_id": userId,
            "class_id": classId
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            //            print("data - \(json)")
            
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