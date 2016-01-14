//
//  YNRefreshHeaderView.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/8.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

enum YNPullRefreshState {

    case Pulling, Normal, Loading
}

struct KeyPaths {
    
    static let ContentOffset = "contentOffset"
    static let PanGestureRecognizerState = "panGestureRecognizer.state"
    
}

class YNRefreshHeaderView: UIView, UIScrollViewDelegate {


    var refreshActionHandler: (()->Void)?
    var state: YNPullRefreshState? {
    
        didSet {
        
            if let _ = state{
            
                switch state! {
                    
                case YNPullRefreshState.Pulling:
                    
                    self.cycleLayer.hidden = false
                    self.activityView.hidden = true
                    
                    break
                case .Loading:
                    
                    self.cycleLayer.hidden = true
                    self.activityView.hidden = false
                    self.activityView.startAnimating()
                
                    break
                case .Normal:
                    
                    self.cycleLayer.hidden = true
                    self.activityView.stopAnimating()
                    self.setOriginalScrollViewContentInset()
                    
                    break
                    
                }
            
            }
            
        }
    }
    
    //MARK: property private
    //用来避免先松手 后达到loading状态
    private var isSetContentInset = true
    private var currentY: CGFloat?
    private var newAngle: CGFloat? {
    
        didSet {
        
            self.cycleLayer.newAngle = newAngle!
        }
    }
   private var startAngle: CGFloat?
    
    //MARK: property UI component
    let cycleLayer: YNCycleLayer = {
    
        return YNCycleLayer()
    
    }()
    
    let activityView: UIActivityIndicatorView = {
    
        let tempView = UIActivityIndicatorView()
        tempView.center = CGPointMake(kCycleCenterX, kCycleCenterY)
        tempView.color = UIColor.blackColor()
        tempView.hidesWhenStopped = true
        tempView.hidden = true
        return tempView
        
    }()
    
    private func scrollView() -> UIScrollView? {
        return superview as? UIScrollView
    }
    
    var observing: Bool = false {
    
        didSet {
        
            guard let scrollView = scrollView() else {return}
            
            if observing {
            
                scrollView.yn_addObserver(self, forKeyPath: KeyPaths.ContentOffset)
                scrollView.yn_addObserver(self, forKeyPath: KeyPaths.PanGestureRecognizerState)
                
            } else {
            
                scrollView.yn_removeObserver(self, forKeyPath: KeyPaths.ContentOffset)
                scrollView.yn_removeObserver(self, forKeyPath: KeyPaths.PanGestureRecognizerState)
            }
            
        }
    }
    
    
    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(activityView)
        activityView.startAnimating()
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.addSublayer(self.cycleLayer)
        
        self.state = YNPullRefreshState.Normal
        
        
//        self.backgroundColor = UIColor.redColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cycleLayer.frame = CGRectMake(0, 0, kScreenWidthRefresh, self.bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: observing
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
//        print(change)
        
        // change = Optional(["new": NSPoint: {0, -1}, "kind": 1])
        
//        print(object)
        
        if keyPath == KeyPaths.ContentOffset {
            
            let changeValue = change!["new"] as? NSValue
            let newPoint = changeValue?.CGPointValue()
            
            if let scrollView = object as? UIScrollView {
            
                self.scrollViewDidScrolla(newPoint!, scrollView: scrollView)
                
            }
            
            
        } else if keyPath == KeyPaths.PanGestureRecognizerState {

        
            if let gestureState = scrollView()?.panGestureRecognizer.state where gestureState == .Ended {
            
                if self.state == .Loading {
                
                    setScrollViewContentInset()
                    
                    self.isSetContentInset = true
                } else {
                
                    self.isSetContentInset = false
                    
                }
                
            }
            
            
        }
        
        
        
    }
    
    func setScrollViewContentInset() {
    
        let offset = max(scrollView()!.contentOffset.y * -1, 0)
        
        var currentInsets = scrollView()!.contentInset
        currentInsets.top = min(offset, kSelfHeight)
        
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            
            self.scrollView()!.contentInset = currentInsets
            
            }, completion: { (isfinish) -> Void in
                
                self.refreshActionHandler!()
                
        })
    }
    
    func setOriginalScrollViewContentInset() {
        
        if let _ = scrollView() {
        
            var currentInsets = scrollView()!.contentInset
            currentInsets.top = 0
            
            UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.AllowUserInteraction, .BeginFromCurrentState], animations: { () -> Void in
                
                self.scrollView()!.contentInset = currentInsets
                
                }) { (isfinish) -> Void in
                    
                    
            }
            
        }
        
        
    }
    
    //MARK: custom motheds
    func scrollViewDidScrolla(contentOffset: CGPoint, scrollView: UIScrollView) {
        
        if self.state != YNPullRefreshState.Loading {
        
            
            let top = kSelfHeight - kOffsetHeight
            
            //当向下拉的距离小于（kSelfHeight + 4）
            if contentOffset.y > -(kSelfHeight + 4) {
                
                if contentOffset.y >= -top {
                    
                    self.cycleLayer.hidden = true
                    self.activityView.hidden = true
                    
                } else if contentOffset.y >= -kSelfHeight {
                    
                    //开始画圆
                    self.state = YNPullRefreshState.Pulling
                    
                    self.currentY = -contentOffset.y
                    
                    let x = (-contentOffset.y - top) * 2 * CGFloat(M_PI)
                    let y = kRadiusOfCycle * 2
                    
                    let angle: CGFloat = x / y - CGFloat(M_PI_2)
                    
                    self.newAngle = angle
                    
                }
                
                
            } else {
                
                
                //contentInset的设置放在scrollViewWillEndDragging方法中 才能平缓过渡 不会有跳跃
        
                self.state = YNPullRefreshState.Loading
                
                
            }
            
        } else {
        
            
            if contentOffset.y == 0 {
            
                self.state = YNPullRefreshState.Normal
            }
//            
//            if !activityView.hidden {
//            
//                //检查contentInset是否设置，如果没设置 就设置一下
//                    
//                    if !isSetContentInset {
//                    
////                        self.activityView.stopAnimating()
//                        
//                        self.state = YNPullRefreshState.Normal
//                        
////                        self.setScrollViewContentInset()
////                        
//                        self.isSetContentInset = true
//                    }
//                
//                    
//            }
            
        }

        
    }
    
    
    
    
    //    //MARK: 刷新成功
    //    func successStopRefresh() {
    //
    //        self.state = YNPullRefreshState.Normal
    //        self.activityView.stopAnimating()
    //        self.removeFromSuperview()
    //
    //        self.observing = false
    //    }
    //
    //    //MARK: 刷新失败
    //    func failureStopRefresh() {
    //
    //        self.state = YNPullRefreshState.Normal
    //        self.activityView.stopAnimating()
    //        self.removeFromSuperview()
    //        
    //        self.observing = false
    //    }
    
}
