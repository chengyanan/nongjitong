//
//  YNWriteReasonViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/28.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNWriteReasonViewController: UIViewController, UITextViewDelegate {
    
    var model: YNCircleModel?
    
    var textViewText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "申请理由"
        self.view.backgroundColor = kRGBA(229, g: 229, b: 229, a: 1)
        
        inputTextView.delegate = self
        
        setInterface()
        setLayout()
    }
    
    func senderAnswerButtonClick() {
        
        self.inputTextView.endEditing(true)
        
        if self.textViewText == nil || self.textViewText == "" {
            
            YNProgressHUD().showText("请输入申请理由", toView: self.view)
            
        } else {
            
            
            //已登陆， 有方案上传
            sendAnswerToserver()
            
        }
        
        
    }
    
    
    
    //MARK: 发送申请请求
    func sendAnswerToserver() {
        
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupUser",
            "a": "applyJoin",
            "group_id": model?.id,
            "user_id": userId,
            "content": self.textViewText
        ]
    
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
            
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //            print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        //                    print("写方案成功")
                        
                        
                        YNProgressHUD().showText("请求发送成功", toView: self.view)
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            
                            let vc = self.navigationController?.popViewControllerAnimated(true)
                            
                            if vc == nil {
                                
                                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                    
                                })
                            }
                        }
                        
                        
                    } else if status == 0 {
                        
                        
                        if let msg = json["msg"] as? String {
                            
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                            
                            
                        }
                    }
                    
                }
                
            } catch {
            
                
                YNProgressHUD().showText("请求失败", toView: self.view)
            }
            
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("数据上传失败", toView: self.view)
        }
        
        
    }
    
    func setInterface() {
        
        //inputTextView
        self.view.addSubview(inputTextView)
    }
    
    func setLayout() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: "senderAnswerButtonClick")
        
        //inputTextView
        Layout().addTopConstraint(inputTextView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(inputTextView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(inputTextView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(inputTextView, toView: nil, multiplier: 0, constant: 216)
    }
    
    let inputTextView: YNTextView = {
        
        let tempView = YNTextView()
        tempView.placeHolder = "请输入申请理由"
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(17)
        return tempView
        
    }()
    
    func popViewController() {
        
        let vc = self.navigationController?.popViewControllerAnimated(true)
        
        if let _ = vc {
        
            
        } else {
        
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                
            })
        }
        
        
    }
    
    //UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        
        //        print(textView.text)
        self.textViewText = textView.text
    }
    
    
    
}
