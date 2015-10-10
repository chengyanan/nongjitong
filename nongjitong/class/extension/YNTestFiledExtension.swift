//
//  YNTestFiledExtension.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/7.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setTextFiledWithLeftImageName(leftImageName: String?, customRightView: UIView?, placeHolder: String?, keyBoardTypePara: UIKeyboardType){
        
        self.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.backgroundColor = UIColor.whiteColor()
        self.translatesAutoresizingMaskIntoConstraints = false
       
        if let _ = leftImageName {
            
            let leftImageView = UIImageView(image: UIImage(named: leftImageName!))
            leftImageView.frame = CGRectMake(0, 0, 38, 30)
            self.leftView = leftImageView
            self.leftView?.contentMode = UIViewContentMode.ScaleAspectFit
            self.leftViewMode = UITextFieldViewMode.Always
        }
        
        if let _ = customRightView {
        
            self.rightView = customRightView
            self.rightViewMode = UITextFieldViewMode.Always
        }
        
        if placeHolder != nil {
            self.placeholder = placeHolder
        }
        
        self.keyboardType = keyBoardTypePara
        
    }
    
}