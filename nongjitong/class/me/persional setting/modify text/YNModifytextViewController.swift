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
    case YNNiceName
    
    //身份证号
    case YNIDNumber

}


class YNModifytextViewController: UIViewController {

    
    
    @IBOutlet weak var textfield: UITextField!
    
    
    //
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
    
    //取消按钮被点击
    @IBAction func cancelDidclick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //保存按钮被点击
    @IBAction func saveButtonclick(sender: AnyObject) {
        
        //向服务器提交数据
        
    }
    
    
}
