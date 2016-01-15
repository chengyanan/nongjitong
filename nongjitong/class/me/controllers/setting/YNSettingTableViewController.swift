//
//  YNSettingTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/12.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNSettingTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let _ = kUser_ID() as? String {
            
            //已登陆
            
            if indexPath.section == 2 {
                
                if indexPath.row == 0 {
                    
                    //退出登录
                    Tools().removeValueForKey(kUserID)
                    Tools().removeValueForKey(kUserIsInformationFinish)
                    Tools().removeValueForKey(kUserWatchListFinish)
                    
                    //                YNExchangeRootController().showSign()
                    
                    //没有登录，直接跳到登录界面
                    let signInVc = YNSignInViewController()
                    
                    let navVc = UINavigationController(rootViewController: signInVc)
                    
                    self.presentViewController(navVc, animated: true, completion: { () -> Void in
                        
                    })
                    
                    
                }
                
            } else if indexPath.section == 0 {
            
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SB_Motift_Password")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        } else {
            
            //没有登录，直接跳到登录界面
            let signInVc = YNSignInViewController()
            
            let navVc = UINavigationController(rootViewController: signInVc)
            
            self.presentViewController(navVc, animated: true, completion: { () -> Void in
                
            })
        }
        
        
        
    }
    
    
    
    //MARK: event response
    @IBAction func isShowMeLocation(sender: UISwitch) {
        
        if let _ = kUser_ID() as? String {
        
        
            if sender.on {
                
                sendData("Y")
                
            } else {
                
                sendData("N")
            }

            
        } else {
            
            //没有登录，直接跳到登录界面
            let signInVc = YNSignInViewController()
            
            let navVc = UINavigationController(rootViewController: signInVc)
            
            self.presentViewController(navVc, animated: true, completion: { () -> Void in
                
            })
        }
        
        
    }
    
    //MARK: 显示数据
    func sendData(isShow: String) {
    
        let dict = ["paraName": "is_showme",
            "text": isShow]
        self.sendInformationToServer(dict)
        
    }
    
    
    func sendInformationToServer(dict: [String: String]) {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpTool().updateUserInformationText(dict, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    //                    let msg = json["msg"] as! String
                    
                    //#warning: msg是更新成功 不是登陆成功
                    //                    print("\n \(msg) \n")
                    
                    //                    YNProgressHUD().showText(msg, toView: self.view)
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        //                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
                
        }
        
    }
    
}
