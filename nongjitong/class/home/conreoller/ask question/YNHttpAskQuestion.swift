//
//  YNHttpAskQuestion.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/10.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpAskQuestion {
    
    //MARK: - 上传问题
    func sendQuestionToServer(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
//        let params: [String: String?] = ["m": "Appapi",
//            "key": "KSECE20XE15DKIEX3",
//            "c": "Index",
//            "a": "getQuestionClass",
//            "parent_id": parentId,
//        ]
        
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

    //MARK: 带图片的
    func sendQuestionToServerWithParams(params: [String: String?], files: [File], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
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

    
}