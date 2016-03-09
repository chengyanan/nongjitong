//
//  YNNewsDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNBottomToolViewDelegate, YNInputViewDelegate, YNNewsCommentTableViewCellDelegate {
    
    var newsModel: YNNewsModel?
    var model: YNNewsDetailsModel?
    
    
    var tableView: UITableView?
    
    var bottomView: YNBottomToolView?
    
    var messageStr = ""
    var isKeyboardShowing = false
    var keyBoardHeight: CGFloat?
    //inputView的高度
    let inputViewHeight: CGFloat = 44
    
    //添加一个随键盘弹出的view
    var bottomInputView: YNInputView?
    
    var cellHeight: CGFloat {
        
        var cellHeight: CGFloat = 0
        
        if let _ = self.model {
        
            cellHeight = 44 + 30 + self.model!.contentHeight
            
            for item in self.model!.comments {
                
                cellHeight += item.height
            }
            
            cellHeight += CGFloat(self.model!.relation.count) * 44
            
        }
      
        return cellHeight
    }
    
    
    
    //MARK: life circle
    init(news: YNNewsModel) {
    
        super.init(nibName: nil, bundle: nil)
        self.newsModel = news
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "新闻详情"
        
        setupInterface()
        setLayout()
        
        //加载数据
        getNewsDetail()
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
    
    //MARK: 设置界面
    func setupInterface() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        let tgr = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        
        self.tableView?.addGestureRecognizer(tgr)
        
        
        let tempinputView = YNInputView()
        tempinputView.delegate = self
        tempinputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempinputView)
        self.bottomInputView = tempinputView
        
        
        self.bottomView = YNBottomToolView()
        self.bottomView?.delegate = self
        self.view.addSubview(bottomView!)
        
       
    }
    
    func setLayout() {
        
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -44)
        
        //bottomView
        Layout().addLeftConstraint(bottomView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(bottomView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(bottomView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(bottomView!, toView: nil, multiplier: 0, constant: 44)
        
        //inputView
        Layout().addBottomConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant:0)
        Layout().addHeightConstraint(bottomInputView!, toView: nil, multiplier: 0, constant: inputViewHeight)
        Layout().addLeftConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(bottomInputView!, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        
            return 3
            
        } else if section == 1 {
        
            if self.model?.comments.count > 0 {
            
                return self.model!.comments.count
                
            }
            
        } else if section == 2 {
        
            if self.model?.relation.count > 0 {
                
                return self.model!.relation.count
            }
            
        }
  
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 1 {
        
            let identify = "CELL_Tags"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNNewsTagsTableViewCell
            
            if cell == nil {
                
                cell = YNNewsTagsTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            if self.model?.newsModel?.tagsArray?.count > 0 {
                
                cell?.dataArray = self.model!.newsModel!.tagsArray!
            }
     
            return cell!
            
            
        } else if indexPath.section == 1 {
        
            let identify = "CELL_Comments"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNNewsCommentTableViewCell
            
            if cell == nil {
                
                cell = YNNewsCommentTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            cell?.model = self.model!.comments[indexPath.row]
            
            cell?.delegate = self
            
            return cell!
            
        } else if indexPath.section == 2 {
            
            
            let identify = "CELL_Relation"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            }
        
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(13)
            cell?.textLabel?.textColor = kRGBA(0, g: 80, b: 169, a: 1)
            cell?.textLabel?.numberOfLines = 2
            cell?.textLabel?.text = self.model?.relation[indexPath.row].title
            
            return cell!
            
        }
        
        
        
        let identify = "CELL_tempCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.textAlignment = .Center
        cell?.selectionStyle = .None
        
        if indexPath.section == 0 {
        
            if indexPath.row == 0 {
            
                cell?.textLabel?.font = UIFont.systemFontOfSize(15)
                cell?.textLabel?.numberOfLines = 2
                cell?.textLabel?.textColor = kRGBA(20, g: 20, b: 20, a: 1)
                cell?.textLabel?.text = self.model?.newsModel?.title
                
            } else if indexPath.row == 2 {
                
                cell?.textLabel?.font = UIFont.systemFontOfSize(13)
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.textColor = UIColor.blackColor()
                cell?.textLabel?.text = self.model?.content
                
            } else {
            
                cell?.textLabel?.text = "rose"
            }
            

        } else {
        
            cell?.textLabel?.text = "rose"
        }
        
        
        return cell!
        
        
    }
    
    
    //MARK: tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 2 {
        
            if self.model?.contentHeight > 0 {
            
                return self.model!.contentHeight
            }
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
        
            return 30
            
            
        } else if indexPath.section == 1 {
        
            if self.model?.comments.count > 0 {
            
                return self.model!.comments[indexPath.row].height
                
            }
            
            
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
            return 0.1
        }
        
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
        
            if self.model?.comments.count > 0 {
            
                return "评论"
                
            }
            
        } else if section == 2 {
        
            if self.model?.relation.count > 0 {
            
                return "相关新闻"
            }
            
            
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section == 2 {
        
            let newsVc = YNNewsDetailsViewController(news: self.model!.relation[indexPath.row])
            
            self.navigationController?.pushViewController(newsVc, animated: true)
        }
        
    }
   
    //MARK: YNNewsCommentTableViewCellDelegate
    func newsCommentTableViewCell(cell: YNNewsCommentTableViewCell) {
        
        self.model?.comments.removeAtIndex(cell.model!.index)
        
        for var i = 0; i < self.model?.comments.count; i++ {
        
            self.model?.comments[i].index = i
        }
        
        self.tableView?.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
        
    }
    
    
    //MARK: YNBottomToolViewDelegate
    func buttonClick(button: UIButton) {
        
        switch button.tag {
        
        case 1:
            
            //TODO: 赞成
            
            break
        case 2:
            
            //反对
//            self.newsCommentVoteOppose()            
            
            break
            
        case 3:
            
            //TODO:收藏
            
            break
        case 4:
            
            //评论
            self.bottomInputView?.textView.becomeFirstResponder()
            
            break
        default:
            break
            
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
            newsComment()
            
            self.view.endEditing(true)
            
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
            self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.model!.comments.count - 1, inSection: 1), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            
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
                    self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.model!.comments.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    
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
    
    
    
    //MARK:加载新闻详情
    func getNewsDetail() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "News",
            "a": "getNewsDetail",
            "id": newsModel?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
//                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let tempdict = json["data"] as! NSDictionary
                        
                        self.model = YNNewsDetailsModel(dict: tempdict)
                        
                        self.tableView?.reloadData()
                        
                        //TODO: 判断移动到评论区
                        
                        if self.messageStr != "" {
                        
                            //有评论
                            
                            self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                            
                            self.messageStr = ""
                        }
                        
                   
                        
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
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
    
        
    }
    
    
    //MARK: 反对某条新闻评论／取消反对
    func newsCommentVoteOppose() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "NewsCommentVote",
            "a": "oppose",
            "comment_id": newsModel?.id,
            "user_id": kUser_ID() as? String
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        //TODO: 投票成功刷新界面
                        
                        
                        
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
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }


    //MARK: 对新闻发表评论
    func newsComment() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "NewsComment",
            "a": "add",
            "news_id": newsModel?.id,
            "user_id": kUser_ID() as? String,
            "content": self.messageStr
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                   
                        //评论成功刷新界面
                        self.getNewsDetail()
                        
                    
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
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    



}
