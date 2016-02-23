//
//  YNCreatVoteViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/17.
//  Copyright © 2016年 农盟. All rights reserved.
//创建投票

import UIKit

enum CreatType {

    //Vote投票,Statistics统计
    case Vote, Statistics
}

class YNCreatVoteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,YNAskQuestionTextCollectionViewCellDelegate, YNTitleCollectionViewCellDelegate, YNAddViteItemViewControllerDelegate, YNFinishInputViewDelegate {

    //MARK: property
    
    var type: CreatType?
    
    let finishViewHeight: CGFloat = 40
    var finishView: YNFinishInputView?
    var groupId: String?
    
    var endTime: String?
    
    init(group_id: String, type: CreatType) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.groupId = group_id
        self.type = type
        
        if self.type == .Vote {
        
            self.title = "新建投票"
            
        } else if self.type == .Statistics {
        
            self.title = "新建统计"
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //描述
    var textViewText: String?
    
    //标题
    var textTitle: String?
    
    //投票选项
    var itemsArray = [String]()
    
    var paraItems: String {
    
        if self.itemsArray.count > 0 {
        
            var itemsStr = ""
            
            for var i = 0; i < self.itemsArray.count; i++ {
            
                if i == self.itemsArray.count - 1 {
                
                    itemsStr += self.itemsArray[i]
                    
                } else {
                
                    itemsStr += self.itemsArray[i]
                    itemsStr += "|"
                }
            }
            
            return itemsStr
        }
        
        return ""
    }
    
    var collectionView: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16
        
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0)
        
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let tempView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        
        tempView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
        
        return tempView
        
    }()
    
    //MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "sendButtonClick")
        
        //计算时间 默认为一个月
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let nowDate = NSDate(timeIntervalSinceNow: 30*24*60*60)
        
        self.endTime = dateFormat.stringFromDate(nowDate)
        
        
        //设置collectionView
        setupCollectionView()

        //添加跟随键盘出现的View
        addFinishView()
        
        //添加键盘通知
        addKeyBoardNotication()
     
        
    }
    
    func addFinishView() {
        
        let finishView = YNFinishInputView()
        finishView.delegate = self
        finishView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, finishViewHeight)
        self.view.addSubview(finishView)
        self.finishView = finishView
        self.view.bringSubviewToFront(self.finishView!)
    }

    //MARK: YNFinishInputViewDelegate
    func finishInputViewFinishButtonDidClick() {
        
        //退出键盘
        hideKeyBoard()
    }
    
    func hideKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    func addKeyBoardNotication() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            //            print(keyboardBounds)
            
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            let keyboardBoundsRect = self.view.convertRect(keyboardBounds, toView: nil)
            
            let deltaY = keyboardBoundsRect.size.height + finishViewHeight
            
            self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, deltaY, 0)
            
            let animations: (()->Void) = {
                
                self.finishView!.transform = CGAffineTransformMakeTranslation(0, -deltaY)
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
                self.finishView!.transform = CGAffineTransformIdentity
                
            }
            
            if duration > 0 {
                
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
                
            } else{
                
                animations()
            }
        }
        
    }
    
    
    func setupCollectionView() {
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNTitleCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_title")
        
         self.collectionView.registerClass(YNAVoteItemCollectionViewCell.self, forCellWithReuseIdentifier: YNAVoteItemCollectionViewCell.identify)
        
        self.collectionView.registerClass(YNEndTimeCollectionViewCell.self, forCellWithReuseIdentifier: YNEndTimeCollectionViewCell.identifier)
        
        Layout().addTopConstraint(collectionView, toView: self.view, multiplier: 1, constant: 64)
        Layout().addLeftConstraint(collectionView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(collectionView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    //MARK: event response
    
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func sendButtonClick() {
        
        self.view.endEditing(true)
        
        if self.textViewText == nil || self.textViewText == "" {
            
            YNProgressHUD().showText("请输入描述", toView: self.view)
            
        } else {
            
            //判断是否登录
            if let _ = kUser_ID() as? String {
                
                if self.itemsArray.count >= 2 {
                
                    //已登陆， 有方案上传
                    sendDataToserver()
                    
                } else {
                
                    YNProgressHUD().showText("至少填写2个选项", toView: self.view)
                }
                
                
                
            } else {
                
                //未登录
                let signInVc = YNSignInViewController()
                let signInNaVc = UINavigationController(rootViewController: signInVc)
                self.presentViewController(signInNaVc, animated: true, completion: { () -> Void in
                    
                })
                
            }
            
            
        }
        
    }
    
    func sendDataToserver() {
        
        let userId = kUser_ID() as? String
        
        var function = ""
        
        if self.type == .Vote {
            
            function = "GroupVote"
            
        } else if self.type == .Statistics {
        
            function = "GroupCount"
        }
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": function,
            "a": "create",
            "group_id": groupId,
            "user_id": userId,
            "descript": self.textViewText,
            "title":self.textTitle,
            "items": self.paraItems,
            "end_time": self.endTime
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        
                        YNProgressHUD().showText("发表成功", toView: self.view)
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                            
                            //退出控制器
                            self.navigationController?.popViewControllerAnimated(true)
                            
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
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSizeMake(self.view.frame.size.width, 60)
            
        } else if indexPath.section == 1 {
            
            return CGSizeMake(self.view.frame.size.width, 80)
        }
    
        
        return CGSizeMake(self.view.frame.size.width, 44)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if section == 2 {
        
            return 2
        }
        
        return 8
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 4
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 2 {
        
            return self.itemsArray.count + 1
        }
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "Cell_Ask_Qustion_title"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNTitleCollectionViewCell
            cell.delegate = self
            
//            cell.textView.text = self.textTitle
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let identify = "Cell_Ask_Qustion_text"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionTextCollectionViewCell
            cell.delegate = self
            cell.inputTextView.placeHolder = "请输入描述"
            cell.inputTextView.font = UIFont.systemFontOfSize(15 )
//            cell.inputTextView.text = self.textViewText
            return cell
            
        } else if indexPath.section == 3 {
      
        
            let identify = YNEndTimeCollectionViewCell.identifier
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNEndTimeCollectionViewCell
            
            cell.endtimeLabel.text = self.endTime
            
            return cell
        }
        
        
        let identify = YNAVoteItemCollectionViewCell.identify
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAVoteItemCollectionViewCell
        
        
        if indexPath.item != 0 {
        
            cell.addButton.text = self.itemsArray[indexPath.item - 1]
            cell.addButton.textColor = UIColor.blackColor()
            
        } else {
        
            if self.type == .Vote {
            
                cell.addButton.text = "添加投票项"
                
            } else if self.type == .Statistics {
            
                cell.addButton.text = "添加统计项"
            }
            
            
            cell.addButton.textColor = UIColor.blueColor()
        }
        
        return cell
    }
    
    //MARK: collectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
        
            //添加投票选项
            let tempVc = YNAddViteItemViewController()
            tempVc.delegate = self
            self.navigationController?.pushViewController(tempVc, animated: true)
            
        }
        
    }
    
    
    //MARK: YNAskQuestionTextCollectionViewCellDelegate
    func askQuestionTextCollectionViewCellTextViewDidEndEditing(text: String) {
        
        self.textViewText = text
    }
    
    //MARK: YNTitleCollectionViewCellDelegate
    func titleCollectionViewCell(cell: YNTitleCollectionViewCell, text: String) {
        
        self.textTitle = text
        
    }
    
    //MARK: YNAddViteItemViewControllerDelegate
    func addViteItemText(text: String) {
        
        self.itemsArray.append(text)
        
        self.collectionView.reloadSections(NSIndexSet(index: 2))
        
    }
    
    //MARK: property
    var askQuestionModel = YNAskQuestionModel()
    
    //上传的图片的最大数量
    let maxImageCount = 3
    
    var dataImageArray = [NSData]()
    
    var tempImageArray = [UIImage]()
    
    var imageArray = [UIImage]() {
        
        didSet {
            
            self.collectionView.reloadSections(NSIndexSet(index: 2))
        }
    }
    
    
    
    
}
