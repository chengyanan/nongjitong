//
//  YNHttpQuestion.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/26.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpQuestion {
    
    func getQuestionListWithClassID(classId: String?, successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        //分类ID,如果指定了该ID，则返回该分类下的问题列表，否则返回全部问题列表
        //page默认20条
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "getQuestionList",
            "class_id": classId,
            "page": nil,
            "descript_length": nil
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
            
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let _ = successFull {
                    
                    successFull!(json: json)
                }
                
            } catch {
            
                print("catch 数据加载失败")
            }
            

            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }
    
    
}