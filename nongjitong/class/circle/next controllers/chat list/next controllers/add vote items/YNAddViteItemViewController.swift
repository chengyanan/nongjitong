//
//  YNAddViteItemViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/21.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNAddViteItemViewControllerDelegate {

    func addViteItemText(text: String)
}

class YNAddViteItemViewController: UIViewController {

    var delegate: YNAddViteItemViewControllerDelegate?
    
    let textField: UITextField = {
    
        let tempView = UITextField()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.borderStyle = UITextBorderStyle.RoundedRect
//        tempView.backgroundColor = UIColor.redColor()
        
        return tempView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "添加投票选项"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .Plain, target: self, action: "sendButtonClick")
        
        self.view.addSubview(textField)
        
        Layout().addTopConstraint(textField, toView: self.view, multiplier: 1, constant: 74)
        Layout().addLeftConstraint(textField, toView: self.view, multiplier: 1, constant: 12)
        Layout().addRightConstraint(textField, toView: self.view, multiplier: 1, constant: -12)
        Layout().addHeightConstraint(textField, toView: nil, multiplier: 0, constant: 38)
        
        
    }
    
    //MARK: event response
    func sendButtonClick() {
        
        self.view.endEditing(true)
        
        if self.textField.text == nil || self.textField.text == "" {
            
            YNProgressHUD().showText("请输入描述", toView: self.view)
            
        } else {
           
            //把选项传给代理
            self.delegate?.addViteItemText(self.textField.text!)
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }
    
    
    
    
    
    
    
}
