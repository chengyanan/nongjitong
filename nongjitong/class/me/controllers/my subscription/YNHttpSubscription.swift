//
//  YNHttpSubscription.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpSubscription {
    
    func addSubcribe(model: YNSubscriptionModel, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "addSubcribe",
            "product_name": model.product_name,
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
}