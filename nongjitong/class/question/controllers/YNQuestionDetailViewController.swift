//
//  YNQuestionDetailViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/4.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNNewAnswerQuestionViewControllerDelegate, YNQuestionAnswerTableViewCellDelegate {
    
    let answerButtonHeight: CGFloat = 44
    let margin: CGFloat = 5
    
     var answerButton: UIButton?
    
    var dataArray = [YNAnswerModel]()
    
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
        
        loadDataFromServer()
        
    }
    
    func loadDataFromServer() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Answer",
            "a": "getQuestionAnswer",
            "question_id": questionModel?.id,
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpQuestionDetail().getQuestionAnswerWithParams(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                print(json)
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    
                    
                    if tempdata.count > 0 {
                        
                        for item in tempdata {
                            
                            let model = YNAnswerModel(dict: item as! NSDictionary)
                            model.questionId = self.questionModel?.id
                            model.isQuestionOwner = (self.questionModel?.user_id == kUser_ID() as? String)
                            self.dataArray.append(model)
                        }
                        
                        self.tableView?.reloadData()
                        
                    } else {
                        
                        //没有数据
                        
                        YNProgressHUD().showText("没有回答", toView: self.view)
                        
                    }
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText("数据加载失败", toView: self.view)
                        print("问题列表数据获取失败: \(msg)")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
    }
    
    func setInterface() {
    
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 50
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        if questionModel?.user_id == kUser_ID() as? String {
        
            //自己的问题不显示回答按钮
            
        } else {
        
            //别人的问题显示回答按钮
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
        
    }
    
    //MARK: event response
    func answerButtonDidClick() {
        
        
        let userId = kUser_ID() as? String
        
        if let _ = userId {
            
            //已登陆，进入问答界面
            let answerVc = YNNewAnswerQuestionViewController()
            answerVc.questionModel = self.questionModel
            
            self.navigationController?.pushViewController(answerVc, animated: true)
            
        } else {
            
            //没有登录，直接跳到登录界面
            let signInVc = YNSignInViewController()
            
            let navVc = UINavigationController(rootViewController: signInVc)
            
            self.presentViewController(navVc, animated: true, completion: { () -> Void in
                
            })
            
        }

    
    }
    
    func setLayout() {
    
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
        if questionModel?.user_id == kUser_ID() as? String {
        
            //自己的问题
            Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
            
        } else {
            
            // other's question
            Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -answerButtonHeight - margin*2)
            
            //answerButton
            Layout().addTopToBottomConstraint(answerButton!, toView: tableView!, multiplier: 1, constant: margin)
            Layout().addHeightConstraint(answerButton!, toView: nil, multiplier: 0, constant: answerButtonHeight)
            Layout().addLeftConstraint(answerButton!, toView: self.view, multiplier: 1, constant: margin)
            Layout().addRightConstraint(answerButton!, toView: self.view, multiplier: 1, constant: -margin)
        }
        
       
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        
            return 1
        }
        
        return self.dataArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
           return 1
        }
        
        return 10
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
        
        let model = self.dataArray[indexPath.row]
        
        return model.marginTopBottomLeftOrRight * 3 + model.avatarWidthHeight + model.contentRealSize.height + 30
    
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
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNQuestionAnswerTableViewCell
        
        if cell == nil {
        
            cell = YNQuestionAnswerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        if questionModel?.status == "2" || questionModel?.status == "3" {
            
            //该问题已解决
            cell?.isAcceptAnswer = true
            
        } else {
        
            cell?.isAcceptAnswer = false
        }
        
        cell?.answeModel = self.dataArray[indexPath.row]
        cell?.dataIndexPath = indexPath
        cell?.delegate = self
        return cell!
        
    }
    
    //MARK: tableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = YNNewAnswerQuestionViewController()
        vc.questionModel = self.questionModel
        vc.answerModel = self.dataArray[indexPath.row]
        vc.dataIndexPath = indexPath
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: YNNewAnswerQuestionViewControllerDelegate
    func newAnswerQuestionViewController(indexPath: NSIndexPath) {
        
        self.dataArray[indexPath.row].is_accept = "Y"
        self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    //MARK: YNQuestionAnswerTableViewCellDelegate
    func questionAnswerTableViewCellHasAcceptAnswer(IndexPath: NSIndexPath) {
        
        self.dataArray[IndexPath.row].is_accept = "Y"
        self.questionModel?.status = "2"
        
        self.tableView?.reloadData()
    }
    
}
