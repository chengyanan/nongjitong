//
//  YNDateExtension.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/17.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    func isToday() ->Bool {
        
        let calendar = NSCalendar.currentCalendar()
      
        if #available(iOS 8.0, *) {
            
            return calendar.isDateInToday(self)
            
        } else {
            
            // 1.获得当前时间的年月日
            
            let unitFlags: NSCalendarUnit = [.Day, .Month, .Year]
            
            let nowComponent = calendar.components(unitFlags, fromDate: NSDate())
            
            let selfComponent = calendar.components(unitFlags, fromDate: self)
            
            let isSameYear = (nowComponent.year == selfComponent.year)
            let isSameMonth = (nowComponent.month == selfComponent.month)
            let isSameDay = (nowComponent.day == selfComponent.day)
            
            return isSameDay && isSameMonth && isSameYear
        }
        
    }
    
    func isYesterday() ->Bool {
    
        if #available(iOS 8.0, *) {
            
            return NSCalendar.currentCalendar().isDateInYesterday(self)
            
        } else {
        
            let nowDate = NSDate().dateWithYMD()
            
            let selfDate = self.dateWithYMD()
            
            let calendar = NSCalendar.currentCalendar()
            
            let cmps = calendar.components(.Day, fromDate: selfDate, toDate: nowDate, options: NSCalendarOptions(rawValue: 0))
            
            return cmps.day == 1
        }
        
    }
    
    func dateWithYMD() ->NSDate {
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selfStr = dateFormatter.stringFromDate(self)
        return dateFormatter.dateFromString(selfStr)!
    }
    
    func isThisYear() ->Bool {
    
        let calendar = NSCalendar.currentCalendar()
        
        let unitFlags: NSCalendarUnit = [.Year]
        
        let nowComponent = calendar.components(unitFlags, fromDate: NSDate())
        
        let selfComponent = calendar.components(unitFlags, fromDate: self)
        
        return nowComponent.year == selfComponent.year
        
    }
    
    func deltaWithNow() ->NSDateComponents {
        
        let calendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [.Hour, .Minute, .Second]
        
        return calendar.components(unitFlags, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
    }
    
}