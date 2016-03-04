//
//  YNNewsRelationTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsRelationTableViewCell: UITableViewCell {

    
    let postTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
    
    
    let content: UILabel = {
        
        //内容
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.numberOfLines = 3
        tempView.font = UIFont.systemFontOfSize(12)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        return tempView
    }()
    
}
