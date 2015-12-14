//
//  YNNewAnswerQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNNewAnswerQuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNInputViewDelegate {

    var tableView: UITableView?
    //添加一个随键盘弹出的view
    var bottomInputView: YNInputView?
    
    var keyBoardHeight: CGFloat?
    
    //inputView的高度
    let inputViewHeight: CGFloat = 44
    let margin: CGFloat = 5
    
    var questionModel: YNQuestionModel?
    
    var isKeyboardShowing = false
    
    var dataarray = [YNAnswerModel]()
    
    var cellHeight: CGFloat {
    
        var cellHeight: CGFloat = 0
        
        for item in dataarray {
            
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
        
        let dict1: NSDictionary = ["descriptiom": "roseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroserose"]
        
        let model1 = YNAnswerModel(dict: dict1)
        model1.isQuestionOwner = true
        self.dataarray.append(model1)
        
        
        let dict2: NSDictionary = ["descriptiom": "roseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroserose"]
        
        let model2 = YNAnswerModel(dict: dict2)
        model2.isQuestionOwner = false
        
        self.dataarray.append(model2)
    
        setInterface()
        
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
        
        let tempinputView = YNInputView()
        tempinputView.delegate = self
        tempinputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempinputView)
        self.bottomInputView = tempinputView
        
        setLayout()
    }
    
    func setLayout() {
        
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
            let dict1: NSDictionary = ["descriptiom": self.messageStr]
            
            let model1 = YNAnswerModel(dict: dict1)
            model1.isQuestionOwner = false
            model1.isFinish = false
            model1.questionId = questionModel?.id
            self.dataarray.append(model1)
            
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
            self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataarray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            
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
                    self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataarray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    
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
    
    //MARK: scrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideKeyBoard()
    }
    
   
}
