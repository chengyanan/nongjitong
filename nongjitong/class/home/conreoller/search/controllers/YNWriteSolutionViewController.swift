//
//  YNWriteSolutionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/13.
//  Copyright © 2016年 农盟. All rights reserved.
//写解决方案 写预警

import UIKit

enum ActionType {
    
    case WriteProgram, WriteWarning
}

class YNWriteSolutionViewController: UIViewController, YNAskQuestionTextCollectionViewCellDelegate, YNAskQuestionImageCollectionViewCellDelegate, YNFinishInputViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var actionType: ActionType = .WriteProgram {
        
        didSet {
            
            if actionType == .WriteProgram {
                
                self.title = "写方案"
//                inputTextView.placeHolder = "请输入方案详情"
                
            } else if actionType == .WriteWarning {
                self.title = "写预警"
//                inputTextView.placeHolder = "请输入预警详情"
            }
        }
    }
    
    var isOfflineQuestion = false
    
    //解决方案数据模型
    var searchresault: YNSearchResaultModel?
    
    //预警数据模型
    var warningModel: YNEarlyToMyProgramModel?
    
    //写的文字
    var textViewText: String?
    
    var collectionView: UICollectionView = {
    
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16
        
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 12, 0)
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let tempView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        
        tempView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
        
        return tempView
        
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: "sendButtonClick")
        
        
        
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
                
                self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
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

        self.collectionView.frame = self.view.bounds
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.addSubview(collectionView)
        
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNAskQuestionImageCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Image")
        
        self.collectionView.registerClass(YNAskQuestionExplianCollectionCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_explain")
    
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
                
                //已登陆， 有方案上传
                sendDataToserver()
                
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
        
        let params: [String: String?]
        
        if self.actionType == .WriteProgram {
            
            //写方案
            params  = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "DocPrograms",
                "a": "createPrograms",
                "doc_id": searchresault?.id,
                "user_id": userId,
                "content": self.textViewText,
                "title":self.textViewText
            ]
            
        } else {
            //写预警
            
            params  = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "Warning",
                "a": "createWarn",
                "subscribe_id": warningModel?.subscribe[0].id,
                "user_id": userId,
                "content": self.textViewText,
            ]
            
        }
        
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, files: self.uploadImageFilesArray, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            //            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    //                    print("写方案成功")
                    
                    
                    YNProgressHUD().showText("上传成功", toView: self.view)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    
                    
                } else if status == 0 {
                    
                    
                    if let msg = json["msg"] as? String {
                        
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("数据上传失败", toView: self.view)
                
        }
        
       
        
        
    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSizeMake(self.view.frame.size.width, 150)
            
        }
        
        let widthHeight = (self.view.frame.size.width - 2*6) / 3 - 1
        
        return CGSizeMake(widthHeight, widthHeight)
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 1 {
            
            if self.imageArray.count >= maxImageCount {
                
                return maxImageCount
            }
            
            return self.imageArray.count + 1
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "Cell_Ask_Qustion_text"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionTextCollectionViewCell
            cell.delegate = self
            cell.inputTextView.placeHolder = "请输入描述"
            return cell
            
        }
        
        
        let identify = "Cell_Ask_Qustion_Image"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionImageCollectionViewCell
        
        cell.delegate = self
        
        if indexPath.item  == self.imageArray.count {
            
            //添加上传图片的照相机图标
            cell.cameraImage = UIImage(named: "home_ask_question_camera")
            
            
        } else {
            
            cell.image = self.imageArray[indexPath.item]
            cell.index = indexPath.item
        }
        
        
        
        return cell
    }
    
    
    //MARK: YNAskQuestionTextCollectionViewCellDelegate
    func askQuestionTextCollectionViewCellTextViewDidEndEditing(text: String) {
    
        self.textViewText = text
    }
    
    
    //MARK: YNAskQuestionImageCollectionViewCellDelegate
    func askQuestionImageCollectionViewCellImageButtonDidClick() {
        
        selectAlbumOrCamera()
    }
    
    func askQuestionImageCollectionViewCellDeleteButtonDidClick(cell: YNAskQuestionImageCollectionViewCell) {
        
        self.uploadImageFilesArray.removeAtIndex(cell.index!)
        self.tempImageArray.removeAtIndex(cell.index!)
        self.imageArray = tempImageArray
        
    }
    
    //MARK: - actionSheet
    func selectAlbumOrCamera() {
        
        if #available(iOS 8.0, *) {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            //取消按钮
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            })
            alertController.addAction(cancleAction)
            
            //相册
            let albumAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                //打开系统相册
                self.openAlbum(UIImagePickerControllerSourceType.PhotoLibrary)
                
            })
            alertController.addAction(albumAction)
            
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera) {
                
                //相机
                let cameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    
                    //打开系统相机
                    self.openAlbum(UIImagePickerControllerSourceType.Camera)
                    
                })
                alertController.addAction(cameraAction)
                
            }
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                
            })
            
            
        } else {
            
            // Fallback on earlier versions iOS7
            
            actionsheetInIOS8Early()
            
        }
        
    }
    
    //MARK: - 打开系统相册
    func openAlbum(type: UIImagePickerControllerSourceType) {
        
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.sourceType = type
        imagePickerVc.delegate = self
        
        self.presentViewController(imagePickerVc, animated: true) { () -> Void in
            
            
        }
        
        
    }
    
    
    //MARK: - iOS8.3以前actionsheet
    
    func actionsheetInIOS8Early() {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        
        actionSheet.addButtonWithTitle("相册")
        
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera) {
            
            actionSheet.addButtonWithTitle("相机")
            actionSheet.cancelButtonIndex = 2
        } else {
            
            actionSheet.cancelButtonIndex = 1
        }
        actionSheet.addButtonWithTitle("取消")
        
        actionSheet.showInView(self.view)
        
    }
    
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        //相册或相机
        if buttonIndex == 0 {
            //相册
            self.openAlbum(UIImagePickerControllerSourceType.PhotoLibrary)
            
        } else if buttonIndex == 1{
            //相机
            self.openAlbum(UIImagePickerControllerSourceType.Camera)
        }
        
        
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //        print("\ndidFinishPickingMediaWithInfo - \(info)\n")
        
        let mediaType = info["UIImagePickerControllerMediaType"] as! String
        
        if mediaType == "public.image" {
            //图片
            
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
            
            let imageData = UIImageJPEGRepresentation(image, 0.001)
            
            let file = File(name: "photo[]", imageData: imageData!)
            
            self.uploadImageFilesArray.append(file)
            
            self.tempImageArray.append(image)
            
            self.imageArray = self.tempImageArray
            
        } else {
            
            //不是图片
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            //TODO: - 给个不是图片的提示
            
        }
        
        
    }
    
   
    
    //MARK: property
    
    let finishViewHeight: CGFloat = 40
    var finishView: YNFinishInputView?
    
    var askQuestionModel = YNAskQuestionModel()
    
   
    
    //上传的图片的最大数量
    let maxImageCount = 3
    
    var dataImageArray = [NSData]()
    
    var uploadImageFilesArray = [File]()
    var tempImageArray = [UIImage]()
    
    var imageArray = [UIImage]() {
        
        didSet {
            
            self.collectionView.reloadSections(NSIndexSet(index: 1))
        }
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
