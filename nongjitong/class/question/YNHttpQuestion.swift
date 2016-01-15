//
//  YNHttpQuestion.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/26.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpQuestion {
    
    func getQuestionListWithClassID(params:[String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
            
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let _ = successFull {
                    
                    successFull!(json: json)
                }
                
            } catch {
            
                print("catch getQuestionListWithClassID数据加载失败")
            }
            

            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
    
}