//
//  YNSearchSolutionWithImageCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/14.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNSearchSolutionWithImageCell: UITableViewCell {

    var isFirstLayout = true
    
    let marginModel = YNQuestionModelConstant()
    
    var solutionModel: YNSearchSolutionListModel? {
        
        didSet {
            
            if let _ = solutionModel {
                
                if let _ = solutionModel?.summary {
                    
                    self.questionContent.text = solutionModel?.summary!
                }
                
                if let _ = solutionModel?.content {
                    
                    self.questionContent.text = solutionModel?.content!
                }
                
                
                self.state.text = "推荐级别\(solutionModel!.recommend!)"
                
                let str = "查看次数:\(solutionModel!.read_num!)  \(solutionModel!.add_time!)"
                
                self.answerCountAndPostTime.text = str
                
               self.setImageViews(solutionModel?.photos)
            }
            
            
        }
        
    }
    
    func setImageViews(model: [String]?) {
    
        if let temparray = model {
            
            self.imageViewOne.image = nil
            self.imageViewTwo.image = nil
            self.imageViewThree.image = nil
    
            if temparray.count == 1 {
            
                self.imageViewOne.getImageWithURL(temparray[0], contentMode: UIViewContentMode.ScaleToFill)
                
                self.imageViewTwo.hidden = true
                self.imageViewThree.hidden = true
                
            } else if temparray.count == 2 {
            
                self.imageViewOne.getImageWithURL(temparray[0], contentMode: UIViewContentMode.ScaleToFill)
                self.imageViewTwo.getImageWithURL(temparray[1], contentMode: .ScaleToFill)
                
                self.imageViewTwo.hidden = false
                self.imageViewThree.hidden = true
                
            } else if temparray.count == 3 {
                
                self.imageViewOne.getImageWithURL(temparray[0], contentMode: UIViewContentMode.ScaleToFill)
                self.imageViewTwo.getImageWithURL(temparray[1], contentMode: .ScaleToFill)
                self.imageViewThree.getImageWithURL(temparray[2], contentMode: .ScaleToFill)
                self.imageViewTwo.hidden = false
                self.imageViewThree.hidden = false
            }
            
            
        }
        
    }
    
    var earlyToMyProgramModel: YNEarlyToMyProgramModel? {
        
        didSet {
            
            if let _ = earlyToMyProgramModel {
                
                if let _ = earlyToMyProgramModel?.summary {
                    
                    self.questionContent.text = earlyToMyProgramModel!.summary!
                } else {
                    
                    self.questionContent.text = earlyToMyProgramModel?.content
                }
                
                
                self.state.text = "作者: \(earlyToMyProgramModel!.user_name!)"
                
                let str = "查看次数:\(earlyToMyProgramModel!.read_num!)  \(earlyToMyProgramModel!.add_time!)"
                
                self.answerCountAndPostTime.text = str
                
                self.setImageViews(earlyToMyProgramModel?.photos)
            }
            
            
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(questionContent)
        self.contentView.addSubview(state)
        self.contentView.addSubview(answerCountAndPostTime)
        self.contentView.addSubview(imageViewOne)
        self.contentView.addSubview(imageViewTwo)
        self.contentView.addSubview(imageViewThree)
        
        self.selectionStyle = .None
        
//        setLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.solutionModel != nil && self.earlyToMyProgramModel == nil {
            
            if isFirstLayout {
                
                setLayout()
                self.isFirstLayout = false
            }
            
        } else if self.solutionModel == nil && self.earlyToMyProgramModel != nil{
            
            if isFirstLayout {
                
                setLayout()
                self.isFirstLayout = false
            }
        }
        
        
    }
    
    func setLayout() {
        
        //questionContent
        Layout().addTopConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: marginModel.topMargin)
        Layout().addLeftConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: marginModel.leftRightMargin)
        Layout().addRightConstraint(questionContent, toView: self.contentView, multiplier: 1, constant: -marginModel.leftRightMargin)
        
        var leftRightMargin: CGFloat = 0
        
        var imageWidthHeight: CGFloat = 0
        
        var imageMargin: CGFloat = 0
        
        if self.solutionModel != nil && self.earlyToMyProgramModel == nil {
        
            leftRightMargin = self.solutionModel!.marginModel.leftRightMargin
            imageWidthHeight = self.solutionModel!.marginModel.imageWidthHeight!
            imageMargin = self.solutionModel!.marginModel.imageMargin
            
        } else if self.solutionModel == nil && self.earlyToMyProgramModel != nil{
            
            leftRightMargin = self.earlyToMyProgramModel!.marginModel.leftRightMargin
            imageWidthHeight = self.earlyToMyProgramModel!.marginModel.imageWidthHeight!
            imageMargin = self.earlyToMyProgramModel!.marginModel.imageMargin
        }
        
        //imageViewOne
        Layout().addTopToBottomConstraint(imageViewOne, toView: questionContent, multiplier: 1, constant: marginModel.marginBetweenDescriptionAndImages)
        
        Layout().addLeftConstraint(imageViewOne, toView: self.contentView, multiplier: 1, constant: leftRightMargin)
        Layout().addWidthConstraint(imageViewOne, toView: nil, multiplier: 0, constant: imageWidthHeight)
        Layout().addHeightConstraint(imageViewOne, toView: nil, multiplier: 0, constant: imageWidthHeight)
        
        //imageViewTwo
        Layout().addTopBottomConstraints(imageViewTwo, toView: imageViewOne, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(imageViewTwo, toView: imageViewOne, multiplier: 1, constant: imageMargin)
        Layout().addWidthConstraint(imageViewTwo, toView: nil, multiplier: 0, constant: imageWidthHeight)
        
        //imageViewThree
        Layout().addTopBottomConstraints(imageViewThree, toView: imageViewTwo, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(imageViewThree, toView: imageViewTwo, multiplier: 1, constant: imageMargin)
        Layout().addWidthConstraint(imageViewThree, toView: nil, multiplier: 0, constant: imageWidthHeight)
        
        //state
        Layout().addLeftConstraint(state, toView: questionContent, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(state, toView: imageViewOne, multiplier: 1, constant: marginModel.topMargin)
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
        return tempView
    }()
    
    let imageViewOne: UIImageView = {
    
        let tempView = UIImageView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        tempView.tag = 1
        return tempView
        
    }()
    
    let imageViewTwo: UIImageView = {
        
        let tempView = UIImageView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        tempView.tag = 2
        return tempView
        
    }()
    
    let imageViewThree: UIImageView = {
        
        let tempView = UIImageView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        tempView.tag = 3
        return tempView
        
    }()
    
    
}
