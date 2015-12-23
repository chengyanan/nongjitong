//
//  YNMeTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//我

import UIKit

class YNMeTableViewController: UITableViewController {
    
    
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var nickNameLabel: UILabel!
    
    @IBOutlet var userIdlabel: UILabel!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let _ = kUser_ID() {
        
            //已登陆
            if let _ = kUser_AvatarPath() {
                
                if let _ = NSData(contentsOfFile: kUser_AvatarPath()!) {
                    
                    avatarImageView.image = UIImage(data: NSData(contentsOfFile: kUser_AvatarPath()!)!)
                }
                
            }
            
            nickNameLabel.text = kUser_NiceName() as? String
            
            if let userAccount = kUser_MobileNumber() as? String {
            
                userIdlabel.text = "账号: \(userAccount)"
            }
            
            
        } else {
        
            //未登录
            avatarImageView.image = UIImage(named: "user_default_avatar")
            
            nickNameLabel.text = "点击登陆"
            userIdlabel.text = ""
            
        }
        
        
        
    }
    
    //MARK: - tableViewDataSource
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 16
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    
    //MARK: - tableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let _ = kUser_ID() as? String {
        
            //已登陆
            
            if indexPath.section == 0 {
            
                //个人资料
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let settingVc = storyBoard.instantiateViewControllerWithIdentifier("user_information")
                
                self.navigationController?.pushViewController(settingVc, animated: true)
                
            } else if indexPath.section == 1 {
                
                let myquestionVc = YNMyQuestionsViewController()
                
                if indexPath.row == 0 {
                    
                    //我的提问
                    myquestionVc.myType = .MyQuestion
                    
                } else if indexPath.row == 1 {
                    
                    //我的回答
                    myquestionVc.myType = .MyAnswer
                    
                }
                
                self.navigationController?.pushViewController(myquestionVc, animated: true)
                
                
            } else if indexPath.section == 2 {
                
                if indexPath.row == 0 {
                    
                    //我的关注
                    let vc = YNMyWatchListViewController()
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if indexPath.row == 1 {
                    
                    //我的订阅
                    let vc = YNMySubscriptionViewController()
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            } else if indexPath.section == 3 {
            
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting_detail")
                
                self.navigationController?.pushViewController(settingVc, animated: true)
            }
            
            
        } else {
        
            //没有登录，直接跳到登录界面
            let signInVc = YNSignInViewController()
            
            let navVc = UINavigationController(rootViewController: signInVc)
            
            self.presentViewController(navVc, animated: true, completion: { () -> Void in
                
            })
        }
        
       
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "Segue_Informatiom" {
//            
//            let destinationVc = segue.destinationViewController as! YNPersionalSettingTableViewController
//            
//            
//        }
//        
//        
//    }

   
    
}
