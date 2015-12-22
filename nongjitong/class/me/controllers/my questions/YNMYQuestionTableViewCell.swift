//
//  YNMYQuestionTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/22.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNMYQuestionTableViewCell: UITableViewCell {

    let marginModel = YNQuestionModelConstant()
    var model: YNQuestionModel? {
    
        didSet {
        
            
        }
    }
    
    //TODO: 明天改写这个了
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(questionContent)
        self.contentView.addSubview(state)
        self.contentView.addSubview(answerCountAndPostTime)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let questionContent: UILabel = {
        
        //问题内容
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.numberOfLines = 3
        tempView.font = UIFont.systemFontOfSize(15)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let answerCountAndPostTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    let state: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    
}
