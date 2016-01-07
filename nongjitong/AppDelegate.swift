//
//  AppDelegate.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        Tools().registerNotification()
        
        
        if kUser_ID() != nil {//已登陆
        
            let temp = kUser_IsInformationFinish()
            
            if  temp != nil {
        
                //个人资料完善判断是否选择了关注领域
                if let _ = kUser_IsWatchListFinish() {
                
                    //关注领域完善，显示主界面
                    let rootstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                    window?.rootViewController = rootstoryboard.instantiateInitialViewController()
                    
                } else {
                    
                    //关注领域不完善，显示关注领域界面
                    let vc = YNMyWatchListViewController()
                    vc.isFirst = true
                    let navVc = UINavigationController(rootViewController: vc)
                    window?.rootViewController = navVc
                    
                }
                
                
            } else {
                
                //个人资料不完善 显示个人资料页面
                
                let rootstoryboardVc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SB_Add_User_Information_nav") as! UINavigationController
                
                window?.rootViewController = rootstoryboardVc
                
            }
            
        
        } else {
        
//            let signinVc = YNSignInViewController()
//            let NavVc = YNNavigationController(rootViewController: signinVc)
//            window?.rootViewController = NavVc
            
            //未登录, 显示主界面
            let rootstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            window?.rootViewController = rootstoryboard.instantiateInitialViewController()
            
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    //MARK: 通知
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let characterSet = NSCharacterSet(charactersInString: "<>")
        
        let tokenStr = String(deviceToken).stringByTrimmingCharactersInSet(characterSet)
        
        let finalTokenStr = tokenStr.stringByReplacingOccurrencesOfString(" ", withString: "")

        print(finalTokenStr)
        
        senderToken(finalTokenStr)
    }
    
    func senderToken(token: String) {
    
        Tools().sendDeviceTokenToServer(token, successful: { (json) -> Void in
            
                if let status = json["status"] as? Int {

                    if status == 1 {


                        print("Token上传成功")

                    } else if status == 0 {

                        print("Token上传失败")
                        
                        print(json["msg"])
                    }
                    
                }
            
            }) { (error) -> Void in
                
                        print("error - Token上传失败")
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print(error, "注册通知失败")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print(userInfo)
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

