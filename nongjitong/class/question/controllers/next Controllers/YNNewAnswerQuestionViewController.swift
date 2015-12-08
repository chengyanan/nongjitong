//
//  YNNewAnswerQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNNewAnswerQuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    let answerButtonHeight: CGFloat = 44
    let margin: CGFloat = 5
    
    var questionModel: YNQuestionModel?
    
    var dataarray = [YNAnswerModel]()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let dict1: NSDictionary = ["descriptiom": "rose"]
        
        let model1 = YNAnswerModel(dict: dict1)
        model1.isQuestionOwner = true
        self.dataarray.append(model1)
        
        
        let dict2: NSDictionary = ["descriptiom": "roseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroserose"]
        
        let model2 = YNAnswerModel(dict: dict2)
        model2.isQuestionOwner = false
        
        self.dataarray.append(model2)
        
        
        setInterface()
        setLayout()
        
        
        
    }
    
    
    func setInterface() {
    
        //tableView
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
    }
    
    func setLayout() {
        
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -answerButtonHeight - margin*2)
        
//        //answerButton
//        Layout().addTopToBottomConstraint(answerButton!, toView: tableView!, multiplier: 1, constant: margin)
//        Layout().addHeightConstraint(answerButton!, toView: nil, multiplier: 0, constant: answerButtonHeight)
//        Layout().addLeftConstraint(answerButton!, toView: self.view, multiplier: 1, constant: margin)
//        Layout().addRightConstraint(answerButton!, toView: self.view, multiplier: 1, constant: -margin)
        
    }
    
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataarray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //回答
        let identify = "CELL_AnswerQuestion"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNAnswerTableViewCell
        
        if cell == nil {
            
            cell = YNAnswerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        cell?.questionModel = dataarray[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.dataarray[indexPath.row].cellHeight!
    }
   
}
