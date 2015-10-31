//
//  YNHttpTool.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpTool {
    
    //MARK: 提交头像
    func updataUserAvatorImage(files: [File], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
    
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "edge5de7se4b5xd",
            "c": "User",
            "a": "update",
            "id": userId,
        ]

        Network.post(kURL, params: params, files: files, success: { (data, response, error) -> Void in
            
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
    
    
    //MARK: - 提交单项资料
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

   //MARK: - 获取用户资料
    func getUserInformation(successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
    
        let userId = kUser_ID() as? String
        
        let params = ["m": "Appapi",
            "key": "edge5de7se4b5xd",
            "c": "User",
            "a": "getUser",
            "id": userId,
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