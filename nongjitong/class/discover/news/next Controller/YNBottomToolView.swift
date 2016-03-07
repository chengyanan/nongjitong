//
//  YNBottomToolView.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/7.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNBottomToolViewDelegate {

    func buttonClick(button: UIButton)
    
}

class YNBottomToolView: UIView {

    var delegate: YNBottomToolViewDelegate?
    
    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = kRGBA(244, g: 244, b: 244, a: 1)
        
        self.addSubview(voteButton)
        self.addSubview(objectButton)
        self.addSubview(favoriteButton)
        self.addSubview(commentButton)
       
        setLayout()
        
        voteButton.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
        objectButton.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
        favoriteButton.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
        commentButton.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
       
    }
    
    func setLayout() {
    
        //voteButton
        Layout().addLeftConstraint(voteButton, toView: self, multiplier: 1, constant: 0)
        Layout().addTopConstraint(voteButton, toView: self, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(voteButton, toView: self, multiplier: 1, constant: 0)
        
        //objectButton
        Layout().addTopBottomConstraints(objectButton, toView: voteButton, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(objectButton, toView: voteButton, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(objectButton, toView: voteButton, multiplier: 1, constant: 0)
        
        //favoriteButton
        Layout().addTopBottomConstraints(favoriteButton, toView: objectButton, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(favoriteButton, toView: objectButton, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(favoriteButton, toView: objectButton, multiplier: 1, constant: 0)
        
        //commentButton
        Layout().addTopBottomConstraints(commentButton, toView: favoriteButton, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(commentButton, toView: favoriteButton, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(commentButton, toView: favoriteButton, multiplier: 1, constant: 0)
        Layout().addRightConstraint(commentButton, toView: self, multiplier: 1, constant: 0)
        
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: event response
    func buttonClick(sender: UIButton) {
    
        
       self.delegate?.buttonClick(sender)
        
    }
    
    
    let voteButton: UIButton = {
        
        //赞同
        let tempView = UIButton()
        tempView.tag = 1
        tempView.setTitle("0", forState: .Normal)
        tempView.setImage(UIImage(named: "agree_up_vote"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        return tempView
    }()
    
    let objectButton: UIButton = {
        
        //反对
        let tempView = UIButton()
        tempView.tag = 2
        tempView.setTitle("0", forState: .Normal)
        tempView.setImage(UIImage(named: "hand_down_vote"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        
        return tempView
    }()
    
    
    let favoriteButton: UIButton = {
        
        //收藏
        let tempView = UIButton()
        tempView.tag = 3
        tempView.setTitle("收藏", forState: .Normal)
        tempView.setImage(UIImage(named: "favorite"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        
        return tempView
    }()
    
    let commentButton: UIButton = {
        
        //评论
        let tempView = UIButton()
        tempView.tag = 4
        tempView.setTitle("评论", forState: .Normal)
        tempView.setImage(UIImage(named: "comment"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        
        return tempView
        
    }()

    
    
    
    
}
