//
//  YNMotifyPasswordViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/5.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNMotifyPasswordViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var newPassword: UITextField!
    
    @IBOutlet var newPaswordAgain: UITextField!

    @IBOutlet var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "修改密码"
        self.doneButton.layer.cornerRadius = 3
        self.doneButton.clipsToBounds = true
        
        self.doneButton.backgroundColor = UIColor.blueColor()
        
        newPassword.delegate = self
        newPaswordAgain.delegate = self
    }
    
    //MARK: event response
    
    @IBAction func done(sender: AnyObject) {
        
        let str1 = self.newPassword.text
        let str2 = self.newPaswordAgain.text
        
        if  str1 == "" || str2 == "" || (str1 != str2) {
        
            YNProgressHUD().showText("填写不正确", toView: self.view)
            
        } else {
            
            //上传
            sendToServer()
        }
        
    }
    
    func sendToServer() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "update",
            "id": kUser_ID() as? String,
            "password": newPassword.text
        ]
        
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
//            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    
                    YNProgressHUD().showText("修改成功", toView: self.view)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
    }
    
}
