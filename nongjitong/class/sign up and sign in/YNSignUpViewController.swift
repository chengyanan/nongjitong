//
//  YNSignUpViewController.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/7.
//  Copyright (c) 2015年 农盟. All rights reserved.
//  注册页面

import UIKit

//#define iphone6   ScreenHeight == 667

class YNSignUpViewController: UIViewController {
    
    let kMargin: CGFloat = 12
    let kTextFileHeight: CGFloat = 44
    let kVerticalSpace: CGFloat = 3
    let kTopMargin: CGFloat = 18
    let kMarginSignUp: CGFloat = 11
    
    let totalSecong = 120
    let codeDigit: Int = 4
    
    var second: Int = 60
    var timer: NSTimer?
    var code: String?
    var originalContentSize: CGSize?
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注册"
        self.view.backgroundColor = kRGBA(243, g: 240, b: 236, a: 1.0)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(userNameTextFiled)
        scrollView.addSubview(securityCodeTextField)
        scrollView.addSubview(passwordTextFiled)
        scrollView.addSubview(passwordAgainTextFiled)
        scrollView.addSubview(signUpButton)
        
        setupLayout()
        
        addKeyBoardNotification()
        
        addTapGestureRecongizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.timer?.invalidate()
    }
// MARK: - event response
    
    //点击获取验证码
     internal func getCodeButtonHasClicked() {
        
        if Tools().isPhoneNumber(self.userNameTextFiled.text!) {
            
            self.getcodeButton.userInteractionEnabled = false
            self.getcodeButton.backgroundColor = UIColor.grayColor()
            
            //等待动画
            showWaitingSecond()
            
            //生成验证码然后传给服务器,由服务器把验证码传到手机端
            generateCodeAndSendToServer()
        
        } else {
        
            YNProgressHUD().showText("您输入的号码不正确", toView: self.view)
            
        }
        
    }
    
     func signUpButtonHasClicked() {
        
        let allFill : Bool = (self.userNameTextFiled.text!.characters.count != 0) && (self.securityCodeTextField.text!.characters.count != 0) && (self.passwordTextFiled.text!.characters.count != 0) && (self.passwordAgainTextFiled.text!.characters.count != 0)
        
        if allFill {
            
            
            if Tools().isPhoneNumber(self.userNameTextFiled.text!) {
                
                if self.passwordTextFiled.text == self.passwordAgainTextFiled.text {
                    
                    if self.code == self.securityCodeTextField.text {
                   
                        //填写正确, 向服务器发送用户名和密码
                        senderDataToServer()
                        
                    }else {
                   
                        YNProgressHUD().showText("验证码不正确", toView: self.view)
                    }
                    
//                    senderDataToServer()
                    
                } else {
                    
                    YNProgressHUD().showText("密码填写不一致", toView: self.view)
                }
                
            } else {
                
                YNProgressHUD().showText("您输入的号码不正确", toView: self.view)
            }
       
            
        } else {
            
            YNProgressHUD().showText("信息填写不完整", toView: self.view)
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
   
        if kIS_iPhone4() || kIS_iPhone5() {
       
            var userInfo: [NSObject: AnyObject]? = notification.userInfo
            
            let aValue: AnyObject? = userInfo?.removeValueForKey(UIKeyboardFrameEndUserInfoKey)
            
            if let rect = aValue?.CGRectValue {
                
                let height = rect.size.height
                self.originalContentSize = self.scrollView.contentSize
                
                if kIS_iPhone4() {
                    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + height*0.5 - 64);
                }
                
                if kIS_iPhone5() {
                    
                    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height );
                }
            }
            
        }
        
    }
   
     func keyboardWillHide(notification: NSNotification) {
        
        if let _ = self.originalContentSize {
        
            if kIS_iPhone4() || kIS_iPhone5() {
                
                self.scrollView.contentSize = self.originalContentSize!
                
            }
        }
   
        
    }
    
     func tapBackView() {
   
        self.view.endEditing(true)
    }
    
// MARK: - custom method
    
    func showWaitingSecond() {
        
        self.timer = NSTimer(timeInterval: 1, target: self, selector: "addOneSecond", userInfo: nil, repeats: true)
        self.timer?.fire()
        
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func addOneSecond() {

        self.second -= 1
        
//        print(self.second)
        if self.second > 0 {
            
            self.getcodeButton.setTitle("\(self.second)s", forState: UIControlState.Normal)
            
        } else {
       
            self.timer?.invalidate()
            self.getcodeButton.userInteractionEnabled = true
            self.getcodeButton.setTitle("获取", forState: UIControlState.Normal)
            self.getcodeButton.backgroundColor = kStyleColor
            self.second = 60
        }
        
    }
    
     func generateCodeAndSendToServer() {
        
        var code: String = ""
        
        for _ in 1...self.codeDigit {
            
            let number = self.randomInRange(1...4)
            code += String(number)
        }
        
        self.code = code
        
        // 把验证码发给服务器，服务器发到手机端
        senderCodeToServer(code)
        
    }
    
     func senderCodeToServer(code: String) {
   
        let params = ["m": "Appapi",
            "c": "User",
            "a": "sendRegMsg",
            "key": "KSECE20XE15DKIEX3",
            "mobile": self.userNameTextFiled.text,
            "code": code]
        
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            do {
                
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                        self.getcodeButton.userInteractionEnabled = true
                    }
                    
                }
            
            } catch {
            
                
                print("\n出现异常")
            }
            
            
        }) { (error) -> Void in
        
            YNProgressHUD().showText("获取验证码失败", toView: self.view)
            self.getcodeButton.userInteractionEnabled = true
        }
        
       
    }
    
     //点击了注册按钮
     func senderDataToServer() {
        
        self.signUpButton.userInteractionEnabled = false
        
        let params = ["m": "Appapi",
            "c": "User",
            "a": "register",
            "key": "KSECE20XE15DKIEX3",
            "mobile": self.userNameTextFiled.text,
            "password": self.passwordTextFiled.text]
        
        
        let progress: ProgressHUD = YNProgressHUD().showWaitingToView(self.view)
         
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary

            print("data - \(json)")
            
            if let status = json["status"] as? Int {
        
                if status == 1 {
                    
                    //把用户名保存到本地
                    Tools().saveValue(self.userNameTextFiled.text, forKey: kUserKey)
                    Tools().saveValue(json["data"], forKey: kUserID)
                    
                    //转到个人信息页面
//                    YNExchangeRootController().showInformation()
                    
                    let rootstoryboardVc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SB_Add_User_Information") as! YNAddUserInformationTableViewController
                    
                    self.navigationController?.pushViewController(rootstoryboardVc, animated: true)
                    
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                    self.signUpButton.userInteractionEnabled = true
                }
                
            }
            
            
        }) { (error) -> Void in
            
            progress.hideUsingAnimation()
            
            YNProgressHUD().showText("请求失败", toView: self.view)
            self.signUpButton.userInteractionEnabled = true
        }
        
    }

    
    func randomInRange(range: Range<Int>) ->Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return Int(arc4random_uniform(count)) + range.startIndex
    }
    
     func addKeyBoardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
     func addTapGestureRecongizer() {
        
        let tgr: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapBackView")
        self.view.addGestureRecognizer(tgr)
        
    }
    
 // MARK: - getter
    lazy var scrollView: UIScrollView! = {
   
        var tempscrollView = UIScrollView()
        tempscrollView.translatesAutoresizingMaskIntoConstraints = false
        return tempscrollView
    }()
  
     lazy var userNameTextFiled: UITextField! = {
        
        var tempTextFiled = UITextField()
        
        tempTextFiled.setTextFiledWithLeftImageName("register_userName", customRightView: nil, placeHolder: "请输入手机号", keyBoardTypePara: UIKeyboardType.NumberPad)

        return tempTextFiled
        }()
    
     lazy var securityCodeTextField: UITextField! = {
        
        var tempTextFiled = UITextField()
        tempTextFiled.setTextFiledWithLeftImageName("register_verficationCode", customRightView: self.getcodeButton, placeHolder: "验证码", keyBoardTypePara: UIKeyboardType.NumberPad)

        return tempTextFiled
        }()
    
     lazy var getcodeButton: UIButton! = {
        var button = UIButton()
        
        button.frame = CGRectMake(0, 0, 72, 40)
        button.layer.cornerRadius = 3
        button.backgroundColor = kStyleColor
        
        button.setTitle("获取", forState: UIControlState.Normal)
        button.addTarget(self, action: "getCodeButtonHasClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
     lazy var passwordTextFiled: UITextField! = {
        
        var tempTextFiled = UITextField()
        tempTextFiled.secureTextEntry = true
        tempTextFiled.setTextFiledWithLeftImageName("register_password", customRightView: nil, placeHolder: "请输入密码", keyBoardTypePara: UIKeyboardType.Default)
        
        return tempTextFiled
        }()

     lazy var passwordAgainTextFiled: UITextField! = {
        
        var tempTextFiled = UITextField()
        tempTextFiled.secureTextEntry = true
        tempTextFiled.setTextFiledWithLeftImageName("register_password", customRightView: nil, placeHolder: "请再次输入密码", keyBoardTypePara: UIKeyboardType.Default)
        
        return tempTextFiled
        }()

     lazy var signUpButton: UIButton! = {
        var button = UIButton()
        
        button.layer.cornerRadius = 3
        button.backgroundColor = kStyleColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("注册", forState: UIControlState.Normal)
        button.addTarget(self, action: "signUpButtonHasClicked", forControlEvents: UIControlEvents.TouchUpInside)

        return button
        }()

     func setupLayout() {
        
        let scrollViewConstrantVFLH = "H:|[scrollView]|"
        let scrollViewConstrantVFLV = "V:|[scrollView]|"
        
        let scrollViewConstrantH = NSLayoutConstraint.constraintsWithVisualFormat(scrollViewConstrantVFLH, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["scrollView": scrollView])
        let scrollViewConstrantV = NSLayoutConstraint.constraintsWithVisualFormat(scrollViewConstrantVFLV, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["scrollView": scrollView])
        self.view.addConstraints(scrollViewConstrantH)
        self.view.addConstraints(scrollViewConstrantV)
        
        let textFiledWidth = kScreenWidth - kMargin * 2
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-kMargin-[tempTextFiled(textFiledWidth)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kMargin": kMargin, "textFiledWidth": textFiledWidth], views: ["tempTextFiled": userNameTextFiled]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-kTopMargin-[tempTextFiled(kTextFileHeight)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kTopMargin": kTopMargin, "kTextFileHeight": kTextFileHeight], views: ["tempTextFiled": userNameTextFiled]))
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-kMargin-[securityCodeTextField(textFiledWidth)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kMargin": kMargin, "textFiledWidth": textFiledWidth], views: ["securityCodeTextField": securityCodeTextField]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[userNameTextFiled]-kVerticalSpace-[securityCodeTextField(kTextFileHeight)]", options:  NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kVerticalSpace": kVerticalSpace, "kTextFileHeight": kTextFileHeight], views: ["userNameTextFiled": userNameTextFiled, "securityCodeTextField": securityCodeTextField]))
        
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-kMargin-[passwordTextFiled(textFiledWidth)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kMargin": kMargin, "textFiledWidth": textFiledWidth], views: ["passwordTextFiled": passwordTextFiled]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[securityCodeTextField]-kVerticalSpace-[passwordTextFiled(kTextFileHeight)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kVerticalSpace": kVerticalSpace, "kTextFileHeight": kTextFileHeight], views: ["passwordTextFiled": passwordTextFiled, "securityCodeTextField": securityCodeTextField]))
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-kMargin-[passwordAgainTextFiled(textFiledWidth)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kMargin": kMargin, "textFiledWidth": textFiledWidth], views: ["passwordAgainTextFiled": passwordAgainTextFiled]))
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordTextFiled]-kVerticalSpace-[passwordAgainTextFiled(kTextFileHeight)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kVerticalSpace": kVerticalSpace, "kTextFileHeight": kTextFileHeight], views: ["passwordTextFiled": passwordTextFiled, "passwordAgainTextFiled": passwordAgainTextFiled]))
        
        
        let textFiledWidthSignUp = kScreenWidth - kMarginSignUp * 2
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-kMarginSignUp-[signUpButton(textFiledWidthSignUp)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kMarginSignUp": kMarginSignUp, "textFiledWidthSignUp": textFiledWidthSignUp], views: ["signUpButton": signUpButton]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordAgainTextFiled]-kVerticalSpace-[signUpButton(kTextFileHeight)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: ["kVerticalSpace": kVerticalSpace*4, "kTextFileHeight": kTextFileHeight], views: ["passwordAgainTextFiled": passwordAgainTextFiled, "signUpButton": signUpButton]))
    }

}
