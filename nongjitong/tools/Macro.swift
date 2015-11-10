//
//  Macro.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/7.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

let kUserKey = "User_MobileNumber"
let kUserID = "User_ID"
let kUserNiceName = "User_NiceName"
let kUserIsInformationFinish = "User_Information"

func kUser_ID() ->AnyObject? {
    
    return NSUserDefaults.standardUserDefaults().valueForKey(kUserID)
}

func kUser_NiceName() ->AnyObject? {
    
    return NSUserDefaults.standardUserDefaults().valueForKey(kUserNiceName)
}

func kUser_IsInformationFinish() ->AnyObject?  {

    return NSUserDefaults.standardUserDefaults().valueForKey(kUserIsInformationFinish)
}

func kUser_MobileNumber() ->AnyObject? {
   
     return NSUserDefaults.standardUserDefaults().valueForKey(kUserKey)
}

let kURL = "http://192.168.1.9:8083/index.php"


let kScreenWidth = UIScreen.mainScreen().bounds.size.width
let kScreenHeight = UIScreen.mainScreen().bounds.size.height

func kIS_iPhone4() ->Bool { return kScreenHeight == 480}
func kIS_iPhone5() ->Bool { return kScreenHeight == 568}
func kIS_iPhone6() ->Bool {return kScreenHeight == 667}

func kIOS7() ->Bool { return atof(UIDevice.currentDevice().systemVersion) < 8 }

func kIS_iPhone6Plus() ->Bool {return kScreenHeight > 667}

func kRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) ->UIColor { return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)}

let kStyleColor: UIColor = {

    return kRGBA(111, g: 225, b: 59, a: 1)

}()
