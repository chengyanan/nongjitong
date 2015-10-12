//
//  YNModifytextViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/10.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

enum YNTextType {
    
    //昵称
    case NiceName
    
    //姓名
    case UserName
    
    //身份证号
    case IDNumber
    
    //手机号
    case MobileNumber

}


protocol YNModifytextViewControllerDelegate {
    
    func modifytextViewController(modifytextViewController: YNModifytextViewController, text: String?)
}

class YNModifytextViewController: UIViewController {

    //MARK: - public proporty
    var textType: YNTextType? {
    
        didSet {
        
            switch textType! {
            
            case .NiceName:
                self.title = "昵称"
            case .MobileNumber:
                self.title = "电话号码"
            case .UserName:
                self.title = "姓名"
            case .IDNumber:
                self.title = "身份证号"
                
            
            }
        }
    
    }
    var delegate: YNModifytextViewControllerDelegate?
    
    //MARK: - private proporty
    @IBOutlet weak var textfield: UITextField!
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.leftView = UIView(frame: CGRectMake(0, 0, 16, 10))
        textfield.leftViewMode = UITextFieldViewMode.Always
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textfield.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    
    //MARK: - event response
    //取消按钮被点击
    @IBAction func cancelDidclick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //保存按钮被点击
    @IBAction func saveButtonclick(sender: AnyObject) {
        
        if self.textType == YNTextType.NiceName {
        
            if textfield.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            
                YNProgressHUD().showText("请填写昵称", toView: self.view)
            } else {
            
                //TODO:向服务器提交昵称
                
                
                //提交成功之后把数据传给代理控制器
                self.delegate?.modifytextViewController(self, text: textfield.text)
                
            }
            
            
        } else if self.textType == YNTextType.UserName {
            
            //TODO:向服务器提交姓名
            
            
            //提交成功之后把数据传给代理控制器
            self.delegate?.modifytextViewController(self, text: textfield.text)
            
        } else if self.textType == YNTextType.IDNumber {
            
            //TODO:向服务器提交身份证号
            
            
            //提交成功之后把数据传给代理控制器
            self.delegate?.modifytextViewController(self, text: textfield.text)
            
        } else if self.textType == YNTextType.MobileNumber {
            
            if textfield.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
                
                YNProgressHUD().showText("请填写号码", toView: self.view)
                
            } else {
                
                //TODO:向服务器提交手机号
                
                
                //提交成功之后把数据传给代理控制器
                self.delegate?.modifytextViewController(self, text: textfield.text)
                
            }

        }
        
        
    }
    
    
}
