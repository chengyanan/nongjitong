//
//  YNHttpTool.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpTool {
    
    func updateUserInformationText(dict: [String: String], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let userId = kUser_ID() as? String
        
        let paraName = dict["paraName"]! as String
        let text = dict["text"]! as String
        
        let params = ["m": "Appapi",
                    "key": "edge5de7se4b5xd",
                      "c": "User",
                      "a": "update",
                     "id": userId,
               "\(paraName)": text
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