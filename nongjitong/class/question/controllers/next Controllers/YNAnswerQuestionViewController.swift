//
//  YNAnswerQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/7.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNAnswerQuestionViewControllerDelegate {

    func answerSuccessfully(model: YNAnswerModel)
}

class YNAnswerQuestionViewController: UIViewController, UITextViewDelegate {

    var questionModel: YNQuestionModel?
    
    var textViewText: String?
    
    var delegate: YNAnswerQuestionViewControllerDelegate?
    
    init(questionModel:YNQuestionModel) {
        
       super.init(nibName: nil, bundle: nil)
       self.questionModel = questionModel
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(questionModel!.user_name)的提问"
        self.view.backgroundColor = kRGBA(229, g: 229, b: 229, a: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")

        inputTextView.delegate = self
    
        setInterface()
        setLayout()
    }
    
    func senderAnswerButtonClick() {
    
        self.inputTextView.endEditing(true)
        
        if self.textViewText == nil || self.textViewText == "" {
        
            YNProgressHUD().showText("请输入回答", toView: self.view)
            
        } else {
        
            //有回答上传
            sendAnswerToserver()
        }
        
        
    }
    
    
    func sendAnswerToserver() {
        
        let userId = kUser_ID() as? String
        let username = kUser_NiceName() as? String
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Answer",
            "a": "answer",
            "question_id": questionModel?.id,
            "user_id": userId,
            "user_name": username,
            "content": self.textViewText
        ]
        
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpAnswerQuestion().answerWithParams(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()

            
//            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
//                    print("回答成功")
                    
                    let model = YNAnswerModel()
                    model.avatar = ""
                    model.user_name = username
                    model.content = self.textViewText
                    
                    self.delegate?.answerSuccessfully(model)
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else if status == 0 {
                    
                    
                    if let msg = json["msg"] as? String {
                    
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        
                    }
                }
                
            }
            
            
            }, failureFul: { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("数据加载失败", toView: self.view)
                
        })
    }
    
    func setInterface() {
    
        //inputTextView
        self.view.addSubview(inputTextView)
    }
    
    func setLayout() {
    
        //inputTextView
        Layout().addTopConstraint(inputTextView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(inputTextView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(inputTextView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(inputTextView, toView: nil, multiplier: 0, constant: 216)
    }
    
    let inputTextView: YNTextView = {
        
        let tempView = YNTextView()
        tempView.placeHolder = "请输入答案"
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
