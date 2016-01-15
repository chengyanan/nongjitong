//
//  YNHttpNearBy.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/24.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpNearBy {
    
    //更新用户坐标
    func updatePositionWithParam(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
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
    
    //取得附近的用户信息
    func nearUserPositionWithParam(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
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
    
    //取得附近的问题
    func nearQuestionWithParam(params: [String: String?], successFull: ((json: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
                
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let _ = successFull {
                    
                    successFull!(json: json)
                }
                
            } catch {
                
                print("catch nearQuestionWithParam数据加载失败")
            }
            
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
                
                
        }
        
        
    }

    
    
}