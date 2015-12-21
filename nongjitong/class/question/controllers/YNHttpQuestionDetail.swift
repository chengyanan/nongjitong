//
//  YNHttpQuestionDetail.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/18.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpQuestionDetail {
    
    func acceptAnswerWithParams(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
            
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let _ = successFull {
                    
                    successFull!(json: json)
                }
                
            } catch {
            
                print("json parse fail")
            }
            
            
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
    func getQuestionAnswerWithParams(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
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
    
    func answerWithParams(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
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