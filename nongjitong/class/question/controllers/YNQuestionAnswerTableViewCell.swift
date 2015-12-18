//
//  YNQuestionAnswerTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/18.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionAnswerTableViewCell: UITableViewCell {

    var answeModel: YNAnswerModel? {
    
        didSet {
        
            self.textLabel?.text = answeModel?.content
        }
    }
    
}
