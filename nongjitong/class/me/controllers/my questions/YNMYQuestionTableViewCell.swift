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
        
            if model!.descript == "" {
            
                self.questionContent.text = "没有问题描述"
                
            } else {
            
                self.questionContent.text = model!.descript
            }
            
            
            if model?.status == "2" || model?.status == "3" {
            
                self.state.text = "已解决"
                self.state.textColor = UIColor.greenColor()
                
            } else {
            
                self.state.text = "待解决"
                self.state.textColor = UIColor.redColor()
            }
            
            self.answerCountAndPostTime.text = "回答:\(model!.answer_count!) | \(model!.createTime!)"
            
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(questionContent)
        self.contentView.addSubview(state)
        self.contentView.addSubview(answerCountAndPostTime)
        
        self.selectionStyle = .None
        
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
    
        //questionContent
        Layout().addTopConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: marginModel.topMargin)
        Layout().addLeftConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: marginModel.leftRightMargin)
        Layout().addRightConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: -marginModel.leftRightMargin)
        
        //state
        Layout().addLeftConstraint(state, toView: questionContent, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(state, toView: questionContent, multiplier: 1, constant: marginModel.topMargin)
        Layout().addHeightConstraint(state, toView: nil, multiplier: 0, constant: marginModel.answerCountHeight)
        Layout().addWidthConstraint(state, toView: nil, multiplier: 0, constant: 80)
        
        //answerCountAndPostTime
        Layout().addTopBottomConstraints(answerCountAndPostTime, toView: state, multiplier: 1, constant: 0)
        Layout().addRightConstraint(answerCountAndPostTime, toView: questionContent, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(answerCountAndPostTime, toView: state, multiplier: 1, constant: marginModel.leftRightMargin)
        
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
    
    let state: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.adjustsFontSizeToFitWidth = true
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
        tempView.textAlignment = .Right
        //        tempView.backgroundColor = UIColor.redColor()
        return tempView
    }()
    
    
}
