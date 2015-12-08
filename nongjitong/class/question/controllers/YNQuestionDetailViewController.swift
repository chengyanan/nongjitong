//
//  YNQuestionDetailViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/4.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let answerButtonHeight: CGFloat = 44
    let margin: CGFloat = 5
    
     var answerButton: UIButton?
    
    var questionModel: YNQuestionModel?
    
    var tableView: UITableView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(questionModel!.user_name)的提问"
        self.view.backgroundColor = UIColor.whiteColor()
        
        setInterface()
        setLayout()
    }
    
    func setInterface() {
    
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        
        let tempButton = UIButton()
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.layer.cornerRadius = 3
        tempButton.clipsToBounds = true
        tempButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        tempButton.setImage(UIImage(named: "ic_list_answer"), forState: .Normal)
        tempButton.setTitle("我要回答", forState: .Normal)
        tempButton.addTarget(self, action: "answerButtonDidClick", forControlEvents: .TouchUpInside)
        tempButton.backgroundColor = kRGBA(46, g: 163, b: 70, a: 1)
        self.view.addSubview(tempButton)
        self.answerButton = tempButton
        
    }
    
    func answerButtonDidClick() {
        
        let answerVc = YNNewAnswerQuestionViewController()
        answerVc.questionModel = self.questionModel
    
        self.navigationController?.pushViewController(answerVc, animated: true)
    }
    
    func setLayout() {
    
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -answerButtonHeight - margin*2)
        
        //answerButton
        Layout().addTopToBottomConstraint(answerButton!, toView: tableView!, multiplier: 1, constant: margin)
        Layout().addHeightConstraint(answerButton!, toView: nil, multiplier: 0, constant: answerButtonHeight)
        Layout().addLeftConstraint(answerButton!, toView: self.view, multiplier: 1, constant: margin)
        Layout().addRightConstraint(answerButton!, toView: self.view, multiplier: 1, constant: -margin)
        
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        
            return 1
        }
        
        return 10
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
           return 1
        }
        
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
        
            return "回答"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 {
        
            return 0.5
        }
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return questionModel!.height!
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //问题
        if indexPath.section == 0 {
        
            let identify = "CELL_QuestionDetail"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNQuestionTableViewCell
            
            if cell == nil {
                
                cell = YNQuestionTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            cell?.model = questionModel
            
            return cell!
        }
        
        //回答
        let identify = "CELL_Answer"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
        
    }
    
    
    
}
