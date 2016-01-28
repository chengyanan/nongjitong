//
//  YNEarlyOtherSubscribeCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNEarlyOtherSubscribeCell: UITableViewCell {
    
    var model: YNEarlyToMyProgramModel? {
    
        didSet {
        
            if model!.subscribe.count >= 2 {
                
                let subscribe1 = model!.subscribe[0]
                let subscribe2 = model!.subscribe[1]
                
                let str1 = "  \(subscribe1.class_name!)  \(subscribe1.city_name!)  \(subscribe1.range!)"
                let str2 = "  \(subscribe2.class_name!) \(subscribe2.city_name!)  \(subscribe2.range!)"
                
                subscribeLabel.text = "  \(model!.user_name!)"
                subscribeOne.text = str1
                subscribeTwo.text = str2
                
            } else {
                
                let subscribe1 = model!.subscribe[0]
                let str1 = "  \(subscribe1.class_name!)  \(subscribe1.city_name!)  \(subscribe1.range!)"
                subscribeLabel.text = "  \(model!.user_name!)"
                subscribeOne.text = str1
            }
            
        }
    }
    
    @IBOutlet var subscribeLabel: UILabel!
    
    @IBOutlet var subscribeOne: UILabel!
    
    @IBOutlet var subscribeTwo: UILabel!
    
    
}
