//
//  YNTabBarController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNTabBarController: UITabBarController, YNNJTTabBarDeleagte {

    
    @IBOutlet var customTabBar: YNNJTTabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      customTabBar.btnClickDelegate = self
    }

  //MARK: YNNJTTabBarDeleagte
    
    func njtTabBarAskQuestionButtonDidClick() {
        
                if let _ = kUser_ID() as? String {
        
                    //已登陆
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let askVc = mainStoryBoard.instantiateViewControllerWithIdentifier("SB_AskQuestion")
                    
                    
                    self.presentViewController(askVc, animated: true) { () -> Void in
                        
                    }
        
        
                } else {
        
                    //未登录
                    let signInVc = YNSignInViewController()
                    let signInNaVc = UINavigationController(rootViewController: signInVc)
                    self.presentViewController(signInNaVc, animated: true, completion: { () -> Void in
                        
                    })
                    
                }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
