//
//  YNExchangeRootController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNExchangeRootController: UIViewController {
    
    func showHome() {
    
        let rootstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootstoryboard.instantiateInitialViewController()
    
    }
    
    func showSign() {
    
        let signinVc = YNSignInViewController()
        let navVc = YNNavigationController(rootViewController: signinVc)
        UIApplication.sharedApplication().keyWindow?.rootViewController = navVc
        
    }
    
    
}
