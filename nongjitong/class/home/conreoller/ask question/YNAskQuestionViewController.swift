//
//  YNAskQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAskQuestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YNFinishInputViewDelegate, YNAskQuestionImageCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let location = Location()
    
    let finishViewHeight: CGFloat = 40
    var finishView: YNFinishInputView?

    //上传的图片的最大数量
    let maxImageCount = 3
    
    var tempImageArray = [UIImage]()
    var imageArray = [UIImage]() {
    
        didSet {

            self.collectionView.reloadSections(NSIndexSet(index: 1))
        }
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //开始定位
        location.startLocation()
        
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
    
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNAskQuestionImageCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Image")
        
        self.collectionView.registerClass(YNAskQuestionLocationCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Location")
        
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16
        
        let size = CGSizeMake(self.view.frame.size.width, 100)
        print(size)
        
        //        flow.itemSize = size
        
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 12, 0)
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView.collectionViewLayout = flow
        
        self.collectionView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
        
//        self.collectionView.bounces = true
        
//        let tgr = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
//        
//        self.collectionView.addGestureRecognizer(tgr)
    }
    
    func hideKeyBoard() {
    
        self.view.endEditing(true)
    }
    
    //MARK: event response
    @IBAction func cancle(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
        
            return CGSizeMake(self.view.frame.size.width, 120)
            
        } else if indexPath.section == 2 {
        
            return CGSizeMake(self.view.frame.size.width, 50)
        }
        
        let widthHeight = (self.view.frame.size.width - 2*6) / 3 - 1
        
        return CGSizeMake(widthHeight, widthHeight)
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 3
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
            
            return cell
            
        } else if indexPath.section == 2 {
        
            let identify = "Cell_Ask_Qustion_Location"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionLocationCollectionViewCell
            
            cell.coorinate = self.location.cooridate
            
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
    
    //MARK: YNAskQuestionImageCollectionViewCellDelegate
    func askQuestionImageCollectionViewCellImageButtonDidClick() {
        
        selectAlbumOrCamera()
    }
    
    func askQuestionImageCollectionViewCellDeleteButtonDidClick(cell: YNAskQuestionImageCollectionViewCell) {
        
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
        
        let actionSheet = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        
        
        actionSheet.delegate = self
        
        actionSheet.addButtonWithTitle("相册")
        
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera) {
            
            actionSheet.addButtonWithTitle("相机")
            
        }
        
        actionSheet.showInView(self.view)
        
    }
    
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        //相册或相机
        if buttonIndex == 0 {
            //相册
            self.openAlbum(UIImagePickerControllerSourceType.PhotoLibrary)
            
        } else {
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
            
            self.tempImageArray.append(image)
            
            self.imageArray = self.tempImageArray
            
            
            
//            //TODO:向服务器上传头像
//            
//            let imageData = UIImageJPEGRepresentation(image, 0.001)
//            
//            sendImageToServer(imageData!)
//            
//            //MARK: - 上传成功改变该页面的头像
//            self.avatorImageView.image = image
            
        } else {
            
            //不是图片
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            //TODO: - 给个不是图片的提示
            
        }
        
        
    }
    
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
