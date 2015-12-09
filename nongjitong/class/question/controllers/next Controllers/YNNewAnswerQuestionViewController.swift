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
        
        let dict1: NSDictionary = ["descriptiom": "rose"]
        
        let model1 = YNAnswerModel(dict: dict1)
        model1.isQuestionOwner = true
        self.dataarray.append(model1)
        
        
        let dict2: NSDictionary = ["descriptiom": "roseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroseroserose"]
        
        let model2 = YNAnswerModel(dict: dict2)
        model2.isQuestionOwner = false
        
        self.dataarray.append(model2)
        
        
        setInterface()
        addViewWithKeyBoard()
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

    
    func addViewWithKeyBoard() {
        
        //添加键盘通知
        addKeyBoardNotication()
    }
    
    
    func addKeyBoardNotication() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: YNInputViewDelegate
    func inputViewFinishButtonDidClick() {
        
        if self.messageStr == "" {
        
            
        } else {
        
            //TODO:有内容发送
            let dict1: NSDictionary = ["descriptiom": self.messageStr]
            
            let model1 = YNAnswerModel(dict: dict1)
            model1.isQuestionOwner = false
            model1.isFinish = false
            model1.questionId = questionModel?.id
            self.dataarray.append(model1)
            
            //判断tableView是否需要向上移动
            
            self.tableView?.reloadData()
            
            decideIfTableViewNeedMoveUp(model1.cellHeight!)
        }
    }
    
    func decideIfTableViewNeedMoveUp(height: CGFloat) {
        
        print(cellHeight)
        
        if cellHeight >= self.view.frame.size.height - 44 {
            
            
            self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataarray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
        } else {
            
        
            let needScroolHeight = cellHeight + self.keyBoardHeight! + inputViewHeight - self.view.frame.size.height + 64
            
            let animations: (()->Void) = {
                
                if needScroolHeight > 0 {
                    
                    self.tableView?.transform = CGAffineTransformMakeTranslation(0, -needScroolHeight)
                    
//                    if needScroolHeight > self.keyBoardHeight {
//                    
//                        self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataarray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
//                        
//                    } else {
//                    
//                         self.tableView?.transform = CGAffineTransformMakeTranslation(0, -needScroolHeight)
//                    }
                    
                   
                }
                
            }
            
            animations()
        }
        
    }
    
    func inputViewTextViewDidChange(text: String) {
        
        self.messageStr = text
    }
    
    func hideKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            let keyboardBoundsRect = self.view.convertRect(keyboardBounds, toView: nil)
            
            let deltaY = keyboardBoundsRect.size.height
            
            self.keyBoardHeight = deltaY
            
            let needScroolHeight = cellHeight + deltaY + inputViewHeight - self.view.frame.size.height + 64
            
            let animations: (()->Void) = {
                
                self.bottomInputView!.transform = CGAffineTransformMakeTranslation(0, -deltaY)
                
                if needScroolHeight  > deltaY {
                
                    self.tableView?.transform = CGAffineTransformMakeTranslation(0, -deltaY)
                    
                }
//                
//                else {
//                
//                    self.tableView?.transform = CGAffineTransformMakeTranslation(0, needScroolHeight)
//                }
                
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
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataarray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //回答
        let identify = "CELL_AnswerQuestion"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNAnswerTableViewCell
        
        print(indexPath.row)
        
        if cell == nil {
            
            cell = YNAnswerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        cell?.delegate = self
        cell?.questionModel = dataarray[indexPath.row]
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.dataarray[indexPath.row].cellHeight!
    }
    
    //MARK: scrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        hideKeyBoard()
    }
    
    
    //MARK: YNAnswerTableViewCellDelegate
    func answerTableViewCellHiddenKeyboard() {
        hideKeyBoard()
    }
    
   
}
