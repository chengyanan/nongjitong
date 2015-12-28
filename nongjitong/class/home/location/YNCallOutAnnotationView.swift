//
//  YNCallOutAnnotationView.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/14.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import MapKit

class YNCallOutAnnotationView: MKAnnotationView {

    let kArror_height: CGFloat = 12//气泡尖角的高度
    let kCenterOffsetY: CGFloat = -73//中心点的Y向上偏移的高度
    let kSelfViewWidth: CGFloat = 160//自己的宽度
    let kSelfViewHeight: CGFloat = 76//自己的高度
    
    lazy var contentView: UIView = {
        
        return UIView(frame: CGRectMake(0, 0, self.kSelfViewWidth, self.kSelfViewHeight-self.kArror_height))
        
        }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.centerOffset = CGPointMake(0, kCenterOffsetY);
        self.frame = CGRectMake(0, 0, kSelfViewWidth, kSelfViewHeight);
        self.backgroundColor = UIColor.clearColor()
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 出现的动画
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        animateIn()
    }
    
    
    
    func animateIn() {
   
        let scale: CGFloat = 0.001
        self.transform = CGAffineTransformMake(scale, 0, 0, scale, 0, 0)
        
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            
            let scaleIn: CGFloat = 1.1
            self.transform = CGAffineTransformMake(scaleIn, 0, 0, scaleIn, 0, 0)
            
        }) { (Bool) -> Void in
            
          self.animateInStepTwo()
        }
    }
    
    func animateInStepTwo() {
        
        UIView.animateWithDuration(0.075, animations: { () -> Void in
            
            let scale: CGFloat = 1.0
            self.transform = CGAffineTransformMake(scale, 0, 0, scale, 0, 0)
            
            }) { (Bool) -> Void in
                
                
        }
        
    }
    
    //MARK: - 画一个背景气泡
    override func drawRect(rect: CGRect) {
        
        drawInContext(UIGraphicsGetCurrentContext()!)
        
        self.addSubview(contentView)

    }
    
    func drawInContext(context: CGContextRef) {
   
        CGContextSetLineWidth(context, 0.5)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetStrokeColorWithColor(context, kStyleColor.CGColor)
        getDrawPath(context)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
    }
    
    func getDrawPath(context: CGContextRef) {
        
        let rect = self.bounds
        let radius: CGFloat = 6.0
        
        let minx = CGRectGetMinX(rect)
        let midx = CGRectGetMidX(rect)
        let maxx = CGRectGetMaxX(rect)
        let miny = CGRectGetMinY(rect)
        let maxy = CGRectGetMaxY(rect) - kArror_height
        
        CGContextMoveToPoint(context, midx + kArror_height, maxy);
//
//        CGContextAddLineToPoint(context,midx, maxy + kArror_height);
        //        CGContextAddLineToPoint(context,midx - kArror_height, maxy);
        
        
        CGContextAddArcToPoint(context, midx + kArror_height, maxy, midx, maxy + kArror_height, 3)
        CGContextAddArcToPoint(context, midx, maxy + kArror_height, midx - kArror_height, maxy, 3)
        CGContextAddArcToPoint(context, midx - kArror_height, maxy, minx, maxy, 3)
        
        CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
        CGContextAddArcToPoint(context, minx, miny, maxx, miny, radius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
        
        CGContextClosePath(context);
        
    }
    
    //消失的时候有个动画

    
}
