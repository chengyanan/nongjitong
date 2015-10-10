//
//  tools.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/10.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation

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
    
    
}

