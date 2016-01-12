//
//  YNCycleLayer.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/8.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

let kScreenWidthRefresh = UIScreen.mainScreen().bounds.size.width
let kScreenHeightRefresh = UIScreen.mainScreen().bounds.size.height

let kSelfHeight: CGFloat = 60//高度
let kOffsetHeight: CGFloat = 22//整个view还没出来的高度
let kRadiusOfCycle: CGFloat = kOffsetHeight*0.5//半径
let kCycleCenterX: CGFloat = kScreenWidthRefresh*0.5//圆心X
let kCycleCenterY: CGFloat = kOffsetHeight + kRadiusOfCycle//圆心Y

class YNCycleLayer: CALayer {

    var newAngle: CGFloat = 0 {
    
        didSet {
        
            self.setNeedsDisplay()
        }
    }
    
    var startAngle: CGFloat = CGFloat(-90 * M_PI / Double(180))
    
    override init() {
        super.init()
        
        self.newAngle = self.startAngle
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawInContext(ctx: CGContext) {
        
        //填充的颜色
        CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5)
        
        //圆心
        CGContextMoveToPoint(ctx, kCycleCenterX, kCycleCenterY)
        
        //画扇型
        CGContextAddArc(ctx, kCycleCenterX, kCycleCenterY, kRadiusOfCycle, self.startAngle, self.newAngle, 0)
        
        CGContextClosePath(ctx)
        CGContextDrawPath(ctx, CGPathDrawingMode.Fill)
        
        
    }
    
    
}
