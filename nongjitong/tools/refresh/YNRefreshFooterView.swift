//
//  YNRefreshFooterView.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/10.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNRefreshFooterViewDelegate {

    func resetScrollViewBottomContentInset()
}

let kRefreshFooterHeight: CGFloat = 44

class YNRefreshFooterView: UIView {


    var refreshActionHandler: (()->Void)?
    
    var observing: Bool = false {
        
        didSet {
            
            guard let scrollView = scrollView() else {return}
            
            if observing {
                
                scrollView.yn_addObserver(self, forKeyPath: KeyPaths.ContentOffset)
                
            } else {
                
                scrollView.yn_removeObserver(self, forKeyPath: KeyPaths.ContentOffset)
                
            }
            
        }
    }
    
    let activityView: UIActivityIndicatorView = {
        
        let tempView = UIActivityIndicatorView()
        tempView.color = UIColor.blackColor()
        tempView.hidesWhenStopped = true
        tempView.hidden = true
        return tempView
        
    }()
    
    var state: YNPullRefreshState? {
        
        didSet {
            
            if let _ = state {
                
                switch state! {
                    
                case YNPullRefreshState.Pulling:
                    
                    self.activityView.stopAnimating()
                    
                    break
                case .Loading:
                
                    self.activityView.startAnimating()
                
                    break
                case .Normal:
                    
                    self.activityView.stopAnimating()
                    
                    break
                    
                }
                
            }
            
        }
    }
    
    private func scrollView() -> UIScrollView? {
        return superview as? UIScrollView
    }
    
    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(activityView)
        self.state = .Normal
        
//        self.backgroundColor = UIColor.redColor()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    //MARK: 刷新成功
//    func successStopRefresh() {
//        
//        self.state = YNPullRefreshState.Normal
//        
//    }
//    
//    //MARK: 刷新失败
//    func failureStopRefresh() {
//        
//        self.state = YNPullRefreshState.Normal
//       
//    }
    
    func scrollViewContentOffsetDidChange(scrollView: UIScrollView) {
        
        if self.state == .Loading {
            
            //正在加载，什么都不做
        } else if self.state == .Normal {
            
            /**
            *  关键-->
            *  scrollView一开始并不存在偏移量,但是会设定contentSize的大小,所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的
            *  高度;上拉加载的效果就是每次滑动到底部时,再往上拉的时候请求更多,那个时候产生的偏移量,就能让contentOffset.y + 手机屏幕尺寸高大于这
            *  个滚动视图的contentSize.height
            */
            
            if scrollView.contentSize.height > scrollView.frame.size.height {
            
                if scrollView.contentOffset.y + scrollView.frame.size.height + 8 > scrollView.contentSize.height {
                    
                    self.frame = CGRectMake(0, scrollView.contentSize.height, kScreenWidthRefresh, kRefreshFooterHeight)
                    let y = kRefreshFooterHeight/2
                    self.activityView.center = CGPointMake(kCycleCenterX, y)
                    
                    self.state = .Loading
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        scrollView.contentInset = UIEdgeInsetsMake(0, 0, kRefreshFooterHeight, 0)
                        
                        }, completion: { (isfinish) -> Void in
                            
                            
                            //开始加载
                            self.refreshActionHandler!()
                            
                    })
                    
                }
                
                
            }
            
            
        }
        
    }

    
    //MARK: observing
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //        print(change)
        
        // change = Optional(["new": NSPoint: {0, -1}, "kind": 1])
        
        //        print(object)
        
        if keyPath == KeyPaths.ContentOffset {
            
            if let scrollView = object as? UIScrollView {
                
                self.scrollViewContentOffsetDidChange(scrollView)
                
            }
            
        }
      
        
    }

    func setOriginalScrollViewContentInset() {
        
        self.state = YNPullRefreshState.Pulling
        
        var currentInsets = scrollView()!.contentInset
        currentInsets.bottom = 0
        
        UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.AllowUserInteraction, .BeginFromCurrentState], animations: { () -> Void in
            
            self.scrollView()!.contentInset = currentInsets
            
            }) { (isfinish) -> Void in
                
                self.state = YNPullRefreshState.Normal
        }
    }
    
    
    
}
