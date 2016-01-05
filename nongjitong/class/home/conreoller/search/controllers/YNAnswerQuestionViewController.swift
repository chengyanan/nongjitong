//
//  YNAnswerQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/7.
//  Copyright © 2015年 农盟. All rights reserved.
//暂时为写方案界面

import UIKit

enum ActionType {

    case WriteProgram, WriteWarning
}

protocol YNAnswerQuestionViewControllerDelegate {

    func answerSuccessfully(model: YNAnswerModel)
}

class YNAnswerQuestionViewController: UIViewController, UITextViewDelegate {

   var searchresault: YNSearchResaultModel?
    
    var textViewText: String?
    
    var delegate: YNAnswerQuestionViewControllerDelegate?
    
    var actionType: ActionType = .WriteProgram {
    
        didSet {
        
            if actionType == .WriteProgram {
                
                self.title = "写方案"
                inputTextView.placeHolder = "请输入方案详情"
                
            } else if actionType == .WriteWarning {
                self.title = "写预警"
                inputTextView.placeHolder = "请输入预警详情"
            }
        }
    }
    
    var warningModel: YNEarlyToMyProgramModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kRGBA(229, g: 229, b: 229, a: 1)

        inputTextView.delegate = self
    
        setInterface()
        setLayout()
    }
    
    func senderAnswerButtonClick() {
    
        self.inputTextView.endEditing(true)
        
        if self.textViewText == nil || self.textViewText == "" {
        
            YNProgressHUD().showText("请输入方案", toView: self.view)
            
        } else {
        
            //判断是否登录
            if let _ = kUser_ID() as? String {
                
                //已登陆， 有方案上传
                sendAnswerToserver()
                
            } else {
                
                //未登录
                let signInVc = YNSignInViewController()
                let signInNaVc = UINavigationController(rootViewController: signInVc)
                self.presentViewController(signInNaVc, animated: true, completion: { () -> Void in
                    
                })
                
            }
            
            
        }
        
        
    }
    
    
    func sendAnswerToserver() {
        
        let userId = kUser_ID() as? String
    
        let params: [String: String?]
        
        if self.actionType == .WriteProgram {
        
            //写方案
            params  = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "DocPrograms",
                "a": "createPrograms",
                "doc_id": searchresault?.id,
                "user_id": userId,
                "content": self.textViewText,
                "title":self.textViewText
            ]
            
        } else {
            //写预警
            
            params  = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "Warning",
                "a": "createWarn",
                "subscribe_id": warningModel?.subscribe[0].id,
                "user_id": userId,
                "content": self.textViewText,
            ]
            
        }
        
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            //            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    //                    print("写方案成功")
                    
                    
                    YNProgressHUD().showText("上传成功", toView: self.view)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        
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
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(17)
        return tempView
        
    }()
    
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
    
//        print(textView.text)
        self.textViewText = textView.text
    }
    
}
