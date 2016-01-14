//
//  UIScrollView+CYNRefresh.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/8.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

let kRefreshViewHeight = kSelfHeight

extension UIScrollView {

    private struct yn_associatedKeys {
    
        static var headerRefreshView = "headerRefreshView"
        static var footerrefreshView = "footerrefreshView"
        static var observersArray = "observers"
    }
    
    private var yn_observers: [[String: NSObject]] {
    
        get {
        
            if let observers = objc_getAssociatedObject(self, &yn_associatedKeys.observersArray) as? [[String: NSObject]] {
            
                return observers
            } else {
            
                let  observers = [[String : NSObject]]()
                self.yn_observers = observers
                return observers
            }
            
        }
        
        set {
        
            objc_setAssociatedObject(self, &yn_associatedKeys.observersArray, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    public func yn_addObserver(observer: NSObject, forKeyPath keyPath: String) {
    
        let observerInfo = [keyPath: observer]
        
        if yn_observers.indexOf({ $0 == observerInfo}) == nil {
        
            yn_observers.append(observerInfo)
            
            addObserver(observer, forKeyPath: keyPath, options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    public func yn_removeObserver(observer: NSObject, forKeyPath keyPath: String) {
    
        let observerInfo = [keyPath: observer]
        
        if let index = yn_observers.indexOf({ $0 == observerInfo}) {
        
            yn_observers.removeAtIndex(index)
            
            removeObserver(observer, forKeyPath: keyPath)
        }
    }
    
   weak var headerRefreshView: YNRefreshHeaderView? {
    
        get {
        
            return objc_getAssociatedObject(self, &yn_associatedKeys.headerRefreshView) as? YNRefreshHeaderView
        }
        
        set {

            objc_setAssociatedObject(self, &yn_associatedKeys.headerRefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
        

    }
    
    weak var footerRefreshView: YNRefreshFooterView? {
    
        get {
            
            return objc_getAssociatedObject(self, &yn_associatedKeys.footerrefreshView) as? YNRefreshFooterView
        }
        
        set {
            
            objc_setAssociatedObject(self, &yn_associatedKeys.footerrefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
    }
    
    func addHeaderRefreshWithActionHandler(actionHandler: ()->Void) {
    
        let yOrigin = -kRefreshViewHeight
        
        let headerRefreshView = YNRefreshHeaderView(frame: CGRectMake(0, yOrigin, self.bounds.size.width, kRefreshViewHeight))
        headerRefreshView.refreshActionHandler = actionHandler
        addSubview(headerRefreshView)
        self.headerRefreshView = headerRefreshView
        
        headerRefreshView.observing = true
    }
    
    func addFooterRefreshWithActionHandler(actionHandler: ()->Void) {
        
        let footerRefreshView = YNRefreshFooterView(frame: CGRectZero)
    
        footerRefreshView.refreshActionHandler = actionHandler
        addSubview(footerRefreshView)
        self.footerRefreshView = footerRefreshView
        
        footerRefreshView.observing = true
        
    }
    
    func stopHeaderRefresh() {
    
        self.headerRefreshView?.state = YNPullRefreshState.Normal

    }
    
    func stopFooterRefresh() {
    
        self.footerRefreshView?.setOriginalScrollViewContentInset()
    }
    
    func stopRefresh() {
        
        stopHeaderRefresh()
        stopFooterRefresh()
    }

    func addHeaderRefresh() {
        
        if self.headerRefreshView?.superview == nil {
        
            addSubview(self.headerRefreshView!)
            self.headerRefreshView?.state = YNPullRefreshState.Normal
            self.headerRefreshView?.observing = true
        }
        
       
        
    }
    
    func removeHeaderRefresh() {
    
        if let _ = self.headerRefreshView {
        
            self.headerRefreshView?.state = YNPullRefreshState.Normal
            self.headerRefreshView?.observing = false
            
            self.headerRefreshView?.removeFromSuperview()
        }
        
        
    }
    
    func addFooterRefresh() {
    
        if self.footerRefreshView?.superview == nil {
        
            addSubview(self.footerRefreshView!)
            self.footerRefreshView?.state = YNPullRefreshState.Normal
            self.footerRefreshView?.observing = true
        }
        
    }
    
    func removeFooterRefresh() {
    
        if let _ = self.footerRefreshView?.superview {
        
            self.footerRefreshView?.state = YNPullRefreshState.Normal
            self.footerRefreshView?.observing = false
            
            self.footerRefreshView?.removeFromSuperview()
        }
        
    }
    
    func addRefresh() {
    
        addHeaderRefresh()
        addFooterRefresh()
    }
    
    func removeRefresh() {
    
        removeHeaderRefresh()
        removeFooterRefresh()
    }
    
    
}