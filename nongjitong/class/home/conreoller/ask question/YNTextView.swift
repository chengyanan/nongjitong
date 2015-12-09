//
//  YNTextView.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/2.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNTextView: UITextView {

    var placeHolder: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textChanged(notification: NSNotification) {
    
        self.setNeedsDisplay()
    }
    
    
    override func drawRect(rect: CGRect) {
        
        if self.text == "" {
            
            if let _ = self.placeHolder {
            
                let placeHolderRect: CGRect = CGRectMake(10, 8, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 8)
                
                let attributes: [String : AnyObject]? = [NSFontAttributeName: UIFont.systemFontOfSize(17),
                    NSForegroundColorAttributeName: kRGBA(200, g: 200, b: 200, a: 1)]
                
                let str = NSString(string: self.placeHolder!)
                
                str.drawInRect(placeHolderRect, withAttributes: attributes)
            }
    
            
        }
        
        
    }
    
}
