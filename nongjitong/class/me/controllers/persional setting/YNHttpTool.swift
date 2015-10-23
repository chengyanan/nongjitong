//
//  YNHttpTool.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/23.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation

class YNHttpTool {
    
    func updateUserInformationPassword(password: String,successFull: (data: NSDictionary)->Void, failureFul: (error: NSError!)->Void) {
    
        let params = ["m": "Appapi",
            "key": "edge5de7se4b5xd",
            "c": "User",
            "a": "login",
            "password": password
        ]
        
//        let progress = YNProgressHUD().showWaitingToView()
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
//            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            print("data - \(json)")
            
            successFull(data: json)
            
//            if let status = json["status"] as? Int {
//                
//                if status == 1 {
//                    
//                    let dict = json["data"] as! NSDictionary
//                    
//                   
//                    
//                    
//                } else if status == 0 {
//                    
//                    if let msg = json["msg"] as? String {
//                        
////                        YNProgressHUD().showText(msg, toView: self.view)
//                    }
//                }
//                
//            }
            
            }) { (error) -> Void in
                
                failureFul(error: error)
                
//                progress.hideUsingAnimation()
//                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
   
    }
    
    
    func updateUserInformationNiceName(nickname: String?,successFull: ((data: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params = ["m": "Appapi",
                    "key": "edge5de7se4b5xd",
                      "c": "User",
                      "a": "update",
               "nickname": nickname
        ]
        
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            print("\nchenggong\n")
            
            
            }) { (error) -> Void in
                
                
        }
        
    
//        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
//            
//            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
//            
//            print("data - \(json)")
//            
//            if let _ = successFull {
//    
//                successFull!(data: json)
//            }
//    
//            
//            }) { (error) -> Void in
//                
//                if let _ = failureFul {
//                
//                    failureFul!(error: error)
//                }
//                
//                
//        }
        
    }

    func updateUserInformationMobile(nickname: String,successFull: ((data: NSDictionary)->Void)?, failureFul: ((error: NSError!)->Void)?) {
        
        let params = ["m": "Appapi",
            "key": "edge5de7se4b5xd",
            "c": "User",
            "a": "login",
            "nickname": nickname
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            print("data - \(json)")
            
            if let _ = successFull {
                
                successFull!(data: json)
            }
            
            
            }) { (error) -> Void in
                
                if let _ = failureFul {
                    
                    failureFul!(error: error)
                }
        }
        
    }

    
}