//
//  YNNJTTabBar.swift
//  YNCustomTabBar
//
//  Created by 农盟 on 15/11/11.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNNJTTabBarDeleagte {

    func njtTabBarAskQuestionButtonDidClick()
}

class YNNJTTabBar: UITabBar {

    var btnClickDelegate: YNNJTTabBarDeleagte?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(askQuestionButton)
        
        askQuestionButton.addTarget(self, action: "askQuestionButtonDidClick", forControlEvents: .TouchUpInside)
        
        addTagToUITarBarButton()
    }
    
    //MARK: event response
    func askQuestionButtonDidClick() {
    
        self.btnClickDelegate?.njtTabBarAskQuestionButtonDidClick()
    }
    
    func addTagToUITarBarButton() {
    
        var index = 0
        for view in self.subviews {
            
            if view is UIControl && !(view is UIButton) {
                
                view.tag = index
                index += (index == 1) ? 2 : 1
                
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.width / CGFloat(buttonCount)
        let height = self.bounds.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        //set askQuestionButton's  frame
        let buttonFrame = CGRect(x: 0, y: 0, width: width - 12, height: height - 12)
        askQuestionButton.frame = buttonFrame
        askQuestionButton.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5)
        
        //set 4 item's frame
        var isShow = false
        for view in self.subviews {
            
            if view is UIControl && !(view is UIButton) {
                
                    if !isShow {

                        if view.tag == 0 {

                            isShow = true
                        }

                    } else {

                        if view.tag == 0 {

                            view.tag = 3
                        }

                    }
                
//                    print(view.tag)
                
                    view.frame = CGRectOffset(frame, width * CGFloat(view.tag), 0)

            }
            
        }

//         print(self.subviews as NSArray)
    }
    
    
    private let buttonCount = 5
    
    let askQuestionButton: UIButton = {
    
        let tempView = UIButton()
        tempView.setBackgroundImage(UIImage(named: "askQuestionbtn"), forState: .Normal)
        tempView.setTitle("问", forState: .Normal)
        tempView.titleLabel?.font = UIFont.systemFontOfSize(22)
        
        return tempView
    }()
    
}
