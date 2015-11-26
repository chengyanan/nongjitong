//
//  YNHttpSubscription.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpSubscription {
    
    func getSubcribe(successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "getSubcribe",
            "user_id": kUser_ID() as? String
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
    
    func addSubcribe(model: YNSubscriptionModel, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "addSubcribe",
            "class_id": model.class_id,
            "area_id": model.area_id,
            "range": model.range,
            "user_id": kUser_ID() as? String
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
    
    func delSubcribe(model: YNSubscriptionModel, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "delSubcribe",
            "id": model.id
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