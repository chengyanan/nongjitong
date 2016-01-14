//
//  tools.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/10.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

struct Tools {
    
   internal func isPhoneNumber(phoneNumber: String) ->Bool{
        
        let length = phoneNumber.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        if  length != 11  {return false}
        let regular = "^1[3|4|5|7|8|9][0-9]{9}$"
        
        let regex = try? NSRegularExpression(pattern: regular, options: NSRegularExpressionOptions.AnchorsMatchLines)
        
        let resault: NSTextCheckingResult! =  regex?.firstMatchInString(phoneNumber, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, length))
        
        let range = resault.range
        
        return (range.length == 11)
    }
    
    func saveValue(value: AnyObject?, forKey: String) {
   
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefault.setValue(value, forKey: forKey)
    }
    
    func valueForKey(forKey: String) ->AnyObject? {
   
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefault.valueForKey(forKey)
        
    }
    
    func removeValueForKey(forKey: String) {
   
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey(forKey)
    }
    
    func removePresentEncoding(text: String) ->String? {
    
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
        
            return nil
        }
        
        let text1 = text.stringByReplacingOccurrencesOfString("&nbsp;数据来源", withString: "\n数据来源")
        let text2 = text1.stringByReplacingOccurrencesOfString("&nbsp;", withString: "")
        let text3 = text2.stringByReplacingOccurrencesOfString("\r\n", withString: " ")
        let text4 = text3.stringByReplacingOccurrencesOfString("\t", withString: "")
        let text5 = text4.stringByReplacingOccurrencesOfString("&", withString: "")
        let text6 = text5.stringByReplacingOccurrencesOfString("  ", withString: "")
        return text6
    }
    
    //计算label的高度
    func heightForText(text:String, font:UIFont, width:CGFloat) -> CGSize {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size
    }
    
    func resizeImage(name: String) -> UIImage{
        
        let image = UIImage(named: name)
        
        let top =  image!.size.width * 0.5
        let left = image!.size.height * 0.5
        
        let newimage = image!.resizableImageWithCapInsets(UIEdgeInsets(top: top, left: left, bottom: top, right: left), resizingMode: .Stretch)
        
        return newimage
    }
    
    
    //注册推送
    func registerNotification() {
        
        if #available(iOS 8.0, *) {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            
        } else {
            // Fallback on earlier versions
            
            let notificationTypes: UIRemoteNotificationType = [.Badge,.Sound,.Alert]
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(notificationTypes)
            
        }
        
    }
    
    //上传deviceToken
    func sendDeviceTokenToServer(token: String, successful: ((json: NSDictionary)->Void)?, failure: ((error:NSError)->Void)?) {
    
        let userid = kUser_ID() as? String
            
            //已登陆请求数据
            let params: [String: String?] = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "User",
                "a": "addToken",
                "token": token,
                "user_id": userid
            ]

            Network.post(kURL, params: params, success: { (data, response, error) -> Void in
                
                do {
                
                    let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if let _ = successful {
                        
                        successful!(json: json)
                    }
                    
                } catch {
                
                    
                }
                
               
                
                
                }) { (error) -> Void in
                    
                    
                    if let _ = failure {
                    
                        failure!(error: error)
                    }
                    

            }
            
            
    }
    
  
    
}

