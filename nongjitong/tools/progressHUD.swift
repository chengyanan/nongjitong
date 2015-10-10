//
//  progressHUD.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/11.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

 enum ProgressHUDMode: Int {
    
    case Text
    case Indicator
}


struct YNProgressHUD {
    
    internal func showText(text: String, toView: UIView) {
        
        let progressHUD = ProgressHUD.showHudToView(toView)
        progressHUD.mode = ProgressHUDMode.Text
        progressHUD.text = text
    }
    
    internal func showWaitingToView(toView: UIView) -> ProgressHUD{
        
        let hud = ProgressHUD(frame: CGRectMake(toView.center.x-50, toView.center.y-50, 80, 80))
        hud.mode = ProgressHUDMode.Indicator
        toView.addSubview(hud)
        return hud
    }
}


class ProgressHUD: UIView {
    
    let textMaxWidth = kScreenWidth * 0.8
    let textmaxHeight: CGFloat = 50
    let margin: CGFloat = 30
    let kFont = UIFont.boldSystemFontOfSize(16)
    let kCornerRadius: CGFloat = 10
    let kBackgroundColor = kRGBA(0, g: 0, b: 0, a: 0.9)
    
    var timer: NSTimer?
    var textRealWidth: CGFloat?
    var mode: ProgressHUDMode? {
   
        didSet {
       
            if mode == ProgressHUDMode.Indicator {
           
                setUpInterface()
            }
        }
    }
    var text: String? {
        
        didSet {
            
            setUpInterface()
        }
    }
    
    private lazy var textLabel: UILabel! = {
        
        var label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.layer.cornerRadius = self.kCornerRadius
        label.clipsToBounds = true
        label.bounds = CGRectMake(0, 0, self.textMaxWidth, self.textmaxHeight)
        label.backgroundColor = self.kBackgroundColor
        label.textAlignment = NSTextAlignment.Center
        
        label.font = self.kFont
        label.text = self.text
        label.sizeToFit()
        
        self.textRealWidth = min(label.frame.size.width, self.textMaxWidth) + self.margin
        label.bounds = CGRectMake(0, 0, self.textRealWidth!, self.textmaxHeight)
        label.center = self.center
        
        return label
        
        }()
    
    private lazy var indicator: UIActivityIndicatorView! = {
        
        var tempIndication = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        tempIndication.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height/2)
        tempIndication.transform = CGAffineTransform(a: 1.6, b: 0, c: 0, d: 1.6, tx: 0, ty: 0)
        tempIndication.bounds = CGRectMake(0, 0, 30, 30)
//       print(NSStringFromCGPoint(tempIndication.center))
        
        tempIndication.startAnimating()
        return tempIndication
        
        }()
    
   class func showHudToView(view: UIView) ->ProgressHUD{
   
    let hud:ProgressHUD = ProgressHUD(frame: view.bounds)
    
    view.addSubview(hud)
    
    return hud

    }
    
//MARK: custom method
    func setUpInterface() {
   
        if mode == ProgressHUDMode.Text {
       
            self.addSubview(textLabel)
            showUsingAnimation(true)
        
        } else if mode == ProgressHUDMode.Indicator {
            
            self.backgroundColor = kRGBA(0, g: 0, b: 0, a: 0.7)
            self.layer.cornerRadius = 12
            self.clipsToBounds = true
            self.addSubview(indicator)
            showUsingAnimation(false)
            
        }
    }
    
    func showUsingAnimation(animation: Bool) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
        
            self.alpha = 1
        
        }) { (Bool) -> Void in
        
            if animation {
           
                let delay: Double = Double(min(self.textRealWidth!, self.textMaxWidth).native/174.0 * 1)
                let realDelay = max(delay, 1)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(realDelay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    
                    self.hideUsingAnimation()
                })
            }
            
        }
        
    }
    
    func hideUsingAnimation() {
   
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0
        }) { (Bool) -> Void in
            
            self.removeFromSuperview()
        }
        
    }
    
// MARK: lift cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}