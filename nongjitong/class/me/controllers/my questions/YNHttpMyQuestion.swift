//
//  YNHttpMyQuestion.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpMyQuestion {
    
    
    func getQuestionListWithUserID(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
                
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let _ = successFull {
                    
                    successFull!(json: json)
                }
                
            } catch {
                
                print("数据加载失败")
            }
            
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
    
    func getInvolvedQuestionWithUserID(userId: String?, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        //获得用户回答过的问题列表
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "getInvolvedQuestion",
            "user_id": userId,
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
                
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let _ = successFull {
                    
                    successFull!(json: json)
                }
                
            } catch {
                
                print("catch getInvolvedQuestionWithUserID数据加载失败")
            }
            
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
    
}