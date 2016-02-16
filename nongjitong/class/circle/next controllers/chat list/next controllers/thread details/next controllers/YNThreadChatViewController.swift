//
//  YNThreadChatViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/16.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNThreadChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNInputViewDelegate, YNThreadChatTableViewCellDelegate {

    var model: YNThreadModel?
    
    var tableView: UITableView?
    //添加一个随键盘弹出的view
    var bottomInputView: YNInputView?
    
    var keyBoardHeight: CGFloat?
    
    //inputView的高度
    let inputViewHeight: CGFloat = 44
    let margin: CGFloat = 5
    
    var isKeyboardShowing = false
    
    var dataArray = [YNThreadChatAnswerModel]()
    //加载当前的页数
    var pageCount = 1
    
    
    var cellHeight: CGFloat {
        
        var cellHeight: CGFloat = 0
        
        for item in dataArray {
            
            cellHeight += item.cellHeight!
        }
        return cellHeight
    }
    
    
    var messageStr = ""
    
    
    var questionModel: YNQuestionModel?
    
    var answerModel: YNAnswerModel?
    var information: YNUserInformationModel?
    
    
    //MARK: life cycle
    init(model: YNThreadModel) {
    
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "讨论界面"
        
        setInterface()
        
        loadSelfInformation()
        loadMessages()
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
            let dict1: NSDictionary = ["content": self.messageStr]
            
            let model1 = YNThreadChatAnswerModel(dict: dict1)
            
            model1.isMessageOwner = true
            model1.avatar = information?.avatar
            
            model1.isFinish = false
            model1.itemId = model?.id
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
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNThreadChatTableViewCell
        
        if cell == nil {
            
            cell = YNThreadChatTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        cell?.delegate = self
        cell?.indexPath = indexPath
        cell?.model = dataArray[indexPath.row]
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.dataArray[indexPath.row].cellHeight!
    }
    
    //MARK: scrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideKeyBoard()
    }
    
    //MARK: YNThreadChatTableViewCellDelegate
    func answered(indexPath: NSIndexPath) {
        
        self.dataArray[indexPath.row].isFinish = true
    }
    
    //MARK: http load
    func loadSelfInformation() {
        
        //加载用户信息
        
        if let _ = kUser_ID() {
            
            
            let progress = YNProgressHUD().showWaitingToView(self.view)
            YNHttpTool().getUserInformation({ (json) -> Void in
                
                progress.hideUsingAnimation()
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let dict = json["data"] as! NSDictionary
                        
                        let tempInfo = YNUserInformationModel(dict: dict)
                        
                        self.information = tempInfo
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                            
                        }
                    }
                    
                }
                
                
                }) { (error) -> Void in
                    
                    progress.hideUsingAnimation()
                    YNProgressHUD().showText("请求失败", toView: self.view)
                    
            }
            
        }
        
        
    }
    
    
    func loadMessages() {
        
        // 加载消息数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Discuss",
            "a": "getList",
            "item_id": model?.id,
            "user_id": kUser_ID() as? String,
            "page": "\(pageCount)"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            self.tableView?.stopRefresh()
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let temparray = json["data"] as? NSArray
                        
                        if temparray?.count < 20 {
                            
                            //显示加载更多
                            self.isShowLoadMore = false
                            
                        } else {
                            
                            //不显示加载更多
                            self.isShowLoadMore = true
                        }
                        
                        if self.pageCount == 1 {
                            
                            self.dataArray.removeAll()
                        }
                        
                        for item in temparray! {
                            
                            let tempModel:YNThreadChatAnswerModel  = YNThreadChatAnswerModel(dict: item as! NSDictionary)
                            
                            //TODO: 要反回每个message的发出者id 然后和使用者做比较 决定message放左边还是右边， 自己发的放右边
                            
                            tempModel.isMessageOwner = false
                            
                            self.dataArray.append(tempModel)
                            
                        }
                        
                        self.tableView?.reloadData()
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
            } catch {
                
                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                self.tableView?.stopRefresh()
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
    }
    
    //是否显示加载更多
    var isShowLoadMore = false {
        
        didSet {
            
            if isShowLoadMore {
                
                self.tableView?.addFooterRefresh()
            } else {
                
                self.tableView?.removeFooterRefresh()
            }
        }
    }
    
    
}
