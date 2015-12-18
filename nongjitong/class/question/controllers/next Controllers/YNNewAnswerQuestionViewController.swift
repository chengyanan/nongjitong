//
//  YNNewAnswerQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNNewAnswerQuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNInputViewDelegate, YNAnswerTableViewCellDelegate {

    var tableView: UITableView?
    //添加一个随键盘弹出的view
    var bottomInputView: YNInputView?
    
    var keyBoardHeight: CGFloat?
    
    //inputView的高度
    let inputViewHeight: CGFloat = 44
    let margin: CGFloat = 5
    
    var questionModel: YNQuestionModel?
    
    var answerModel: YNAnswerModel?
    
    var isKeyboardShowing = false
    
    var dataArray = [YNAnswerModel]()
    
    var cellHeight: CGFloat {
    
        var cellHeight: CGFloat = 0
        
        for item in dataArray {
            
            cellHeight += item.cellHeight!
        }
        return cellHeight
    }
    
    var messageStr = ""
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "用户的提问"
        self.view.backgroundColor = UIColor.whiteColor()
        
        //设置左上角和右上角
        setLeftItemAndRightItem()
        
        let questionDict: NSDictionary = ["content": "问: \(questionModel!.descript)"]
        let model = YNAnswerModel(dict: questionDict)
        model.user_id = questionModel?.user_id
        model.user_name = questionModel?.user_name
        model.avatar = questionModel?.avatar
        model.add_time = questionModel?.add_time
        model.isQuestionOwner = true
        model.isFinish = true
        self.dataArray.append(model)
        
        setInterface()
        
        loadDataFromServer()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyBoardNotication()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyBoardNotication()
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func setLeftItemAndRightItem() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        if questionModel?.user_id == kUser_ID() as? String {
            
            //提问者可以采纳回答
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "采纳", style: .Plain, target: self, action: "acceptAnswer")
            
        } else {
            
            //不是提问者
        }
        
        
    }
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    func acceptAnswer() {
        
        //TODO: 彩奈回答
    }
    
    //MARK: interface
    func setInterface() {
    
        //tableView
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        let userId = kUser_ID() as? String
        
        if let _ = answerModel {
        
            if userId != questionModel?.user_id && userId != answerModel?.user_id {
                
                //既不是回答者 也不是提问者
                
            } else {
                
                let tempinputView = YNInputView()
                tempinputView.delegate = self
                tempinputView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(tempinputView)
                self.bottomInputView = tempinputView
            }
            
            
        } else {
        
            
            let tempinputView = YNInputView()
            tempinputView.delegate = self
            tempinputView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(tempinputView)
            self.bottomInputView = tempinputView
        }
        
        setLayout()
    }
    
    func setLayout() {
        
        
        let userId = kUser_ID() as? String
        
        
        if let _ = answerModel {
            
            
            if userId != questionModel?.user_id && userId != answerModel?.user_id {
                
                //既不是回答者 也不是提问者
                //tableView
                Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                
                
            } else {
                
                
                //inputView
                Layout().addBottomConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addHeightConstraint(bottomInputView!, toView: nil, multiplier: 0, constant: inputViewHeight)
                Layout().addLeftConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addRightConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
                
                //tableView
                Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
                Layout().addBottomToTopConstraint(tableView!, toView: bottomInputView!, multiplier: 1, constant: margin)
                
            }
        
            
        } else {
        
            //inputView
            Layout().addBottomConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
            Layout().addHeightConstraint(bottomInputView!, toView: nil, multiplier: 0, constant: inputViewHeight)
            Layout().addLeftConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
            Layout().addRightConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
            
            //tableView
            Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
            Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
            Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
            Layout().addBottomToTopConstraint(tableView!, toView: bottomInputView!, multiplier: 1, constant: margin)
        }
        
        
        
    }
    
    //MARK: load data
    func loadDataFromServer() {
        
        let userId = kUser_ID() as? String
        
        var choiceId = ""
    
        
            if let _ = answerModel {
            
                if userId != questionModel?.user_id && userId != answerModel?.user_id  {
                
                    
                    //既不是提问者 也不是回答者
                    choiceId = answerModel!.user_id!
                    
                } else {
                
                    choiceId = userId!
                }
                
            } else {
            
                choiceId = userId!
            }
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Answer",
            "a": "getAnswer",
            "question_id": questionModel?.id,
            "user_id": choiceId
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpAnswerQuestion().getAnswerWithParams(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                print(json)
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        for item in tempdata {
                            
                            let model = YNAnswerModel(dict: item as! NSDictionary)
                            
                            model.questionId = self.questionModel?.id
                            model.isFinish = true
                            if model.user_id == self.questionModel!.user_id {
                                
                                //是问题的主人
                                model.isQuestionOwner = true

                            } else {
                                
                                //是回答者
                                model.isQuestionOwner = false
                
                            }
                            
                            
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

    //MARK: keyBoardNotication
    func addKeyBoardNotication() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyBoardNotication() {
    
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            self.isKeyboardShowing = true
            
            let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            let keyboardBoundsRect = self.view.convertRect(keyboardBounds, toView: nil)
            
            let deltaY = keyboardBoundsRect.size.height
            
            self.keyBoardHeight = deltaY
            
            let needScroolHeight = cellHeight + deltaY + inputViewHeight + 64 - self.view.frame.size.height
            
            let animations: (()->Void) = {
                
                self.bottomInputView!.transform = CGAffineTransformMakeTranslation(0, -deltaY)
                
                if needScroolHeight > 0 {
                    
                    if needScroolHeight  > deltaY {
                        
                        self.tableView?.transform = CGAffineTransformMakeTranslation(0, -deltaY)
                        
                    } else {
                        
                        self.tableView?.transform = CGAffineTransformMakeTranslation(0, -needScroolHeight)
                    }
                    
                }
                
                
            }
            
            if duration > 0 {
                
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
                
                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
                
            } else {
                
                animations()
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            self.isKeyboardShowing = false
            
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animations:(() -> Void) = {
                
                self.bottomInputView!.transform = CGAffineTransformIdentity
                self.tableView!.transform = CGAffineTransformIdentity
            }
            
            if duration > 0 {
                
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
                
            } else{
                
                animations()
            }
        }
        
    }
    
    
    //MARK: YNInputViewDelegate
    func inputViewFinishButtonDidClick() {
        
        if self.messageStr == "" {
        
            
        } else {
        
            //有内容发送
            let dict1: NSDictionary = ["content": self.messageStr]
            
            let model1 = YNAnswerModel(dict: dict1)
            
            if questionModel?.user_id == kUser_ID() as? String {
                
                //提问者自己追问
                model1.isQuestionOwner = true
                model1.avatar = questionModel?.avatar
                //对方的id
                model1.to_user_id = dataArray[1].user_id
                
            } else {
                
                model1.isQuestionOwner = false
                model1.to_user_id = questionModel?.user_id
                
                //TODO: 传自己的头像
//                model1.avatar = dataArray[1].avatar
            }
            
            model1.isFinish = false
            model1.questionId = questionModel?.id
            self.dataArray.append(model1)
            self.tableView?.reloadData()
            
            //判断tableView是否需要向上移动
            decideIfTableViewNeedMoveUp()
            
            self.messageStr = ""
        }
    }
    
    //判断tableView是否需要向上移动
    func inputViewTextViewDidChange(text: String) {
        
        self.messageStr = text
    }
    
    func decideIfTableViewNeedMoveUp() {
        
        if isKeyboardShowing {
            
            //当有键盘的时候点击发送
            ifTableViewNeedScrollWithKeyboard()
            
        } else {
            
            //当没键盘的时候点击发送
            ifTableViewNeedScrollWithoutKeyboard()
            
        }
        
        
    }
    
    func ifTableViewNeedScrollWithoutKeyboard() {
        
        let tableViewNeedScrollHeight = 64 + cellHeight + inputViewHeight - self.view.frame.size.height
        
        if tableViewNeedScrollHeight > 0 {
            
            //需要滚动
            self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataArray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            
        } else {
            
            //如果cell高度没有超出tableview的高度 不需要滚动
        }
    }
    
    func ifTableViewNeedScrollWithKeyboard() {
        
        let needScroolHeight = 64 + cellHeight + self.keyBoardHeight! + inputViewHeight - self.view.frame.size.height
        
        let animations: (()->Void) = {
            
            if needScroolHeight > 0 {
                
                //最高的滚动高度
                let maxScrollHeight = self.keyBoardHeight!
                
                if needScroolHeight > self.keyBoardHeight! {
                    //如果需要向上移动的距离大于键盘的距离， 就向下移动tableview
                    self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataArray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    
                    self.tableView?.transform = CGAffineTransformMakeTranslation(0, -maxScrollHeight)
                    
                } else {
                    
                    //如果需要向上移动的距离小于键盘的距离， 就向上移动tableview
                    self.tableView?.transform = CGAffineTransformMakeTranslation(0, -needScroolHeight)
                }
                
                
            }
            
        }
        
        animations()
        
    }
    
    
    func hideKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //回答
        let identify = "CELL_AnswerQuestion"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNAnswerTableViewCell
        
        if cell == nil {
            
            cell = YNAnswerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        cell?.delegate = self
        cell?.indexPath = indexPath
        cell?.questionModel = dataArray[indexPath.row]
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.dataArray[indexPath.row].cellHeight!
    }
    
    //MARK: scrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideKeyBoard()
    }
    
    //MARK: YNAnswerTableViewCellDelegate
    func answered(indexPath: NSIndexPath) {
        
        self.dataArray[indexPath.row].isFinish = true
    }
    
    
    
}
