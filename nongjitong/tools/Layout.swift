//
//  Layout.swift
//  2015-08-06
//
//  Created by 农盟 on 15/9/1.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

struct Layout {
    
    func addTopConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
   
        let distanceLabelConstantTop = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Top, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantTop)
        
    }
    
    func addLeftConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantLeft = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Left, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantLeft)
        
    }
    
    func addBottomConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantLeft = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantLeft)
        
    }
    
    func addRightConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantLeft = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Right, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantLeft)
        
    }
    
    func addHeightConstraint(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Height, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
        
    }
    
    func addWidthConstraint(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Width, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
        
    }
    
    func addLeftToRightConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Right, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
        
    }

    func addRightToLeftConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Left, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
        
    }

    
    func addTopToBottomConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
        
    }
    
    func addBottomToTopConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Top, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
        
    }
    
    func addCenterXConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
   
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.CenterX, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
    }
    
    func addCenterYConstraint(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        let distanceLabelConstantHeight = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.CenterY, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(distanceLabelConstantHeight)
    }
    
    func addCenterXYConstraints(view: UIView, toView: UIView, multiplier:CGFloat, constant: CGFloat) {
        
        addCenterXConstraint(view, toView: toView, multiplier: multiplier, constant: constant)
        addCenterYConstraint(view, toView: toView, multiplier: multiplier, constant: constant)
    }
    
    func addWidthHeightConstraints(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
   
        addHeightConstraint(view, toView: toView, multiplier: multiplier, constant: constant)
        addWidthConstraint(view, toView: toView, multiplier: multiplier, constant: constant)
    }
    
    func addWidthToHeightConstraints(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        let widthToHeightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Height, multiplier: multiplier, constant: constant)
        
        view.superview?.addConstraint(widthToHeightConstraint)
    }
    
    func addTopBottomConstraints(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        addTopConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
        addBottomConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
    }
    
    func addLeftTopRightConstraints(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        addLeftConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
        addTopConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
        addRightConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
        
    }

    func addLeftTopBottomConstraints(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        addLeftConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
        addTopBottomConstraints(view, toView: toView!, multiplier: multiplier, constant: constant)
        
    }
    
    func addRightTopBottomConstraints(view: UIView, toView: UIView?, multiplier:CGFloat, constant: CGFloat) {
        
        addRightConstraint(view, toView: toView!, multiplier: multiplier, constant: constant)
        addTopBottomConstraints(view, toView: toView!, multiplier: multiplier, constant: constant)
        
    }
    
    
}