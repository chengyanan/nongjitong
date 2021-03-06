//
//  YNAskQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//提问

import UIKit
import CoreLocation

class YNAskQuestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YNFinishInputViewDelegate, YNAskQuestionImageCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, LocationDelegate, YNSelectedCategoryViewControllerDelegate, YNAskQuestionTextCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var isOfflineQuestion = false
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置collectionView
        setupCollectionView()
        
        //添加跟随键盘出现的View
        addFinishView()
        
        //添加键盘通知
        addKeyBoardNotication()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //开始定位
        location.delegate = self
        location.startLocation()
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
    
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNAskQuestionImageCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Image")
        
        self.collectionView.registerClass(YNAskQuestionLocationCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Location")
        
        self.collectionView.registerClass(YNAskQuestionExplianCollectionCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_explain")
        
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16

        flow.sectionInset = UIEdgeInsetsMake(0, 0, 12, 0)
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView.collectionViewLayout = flow
        
        self.collectionView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
    
    }
    
    //MARK: event response
    @IBAction func cancle(sender: AnyObject) {
        
       if self.navigationController?.viewControllers.count <= 1 {
        
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                
            }
            
       } else {
        
            self.navigationController?.popViewControllerAnimated(true)
            
       }
        
        
    }
    
    @IBAction func postQuestion(sender: AnyObject) {
        
        
        if self.askQuestionModel.descript?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            
            if let _ = self.askQuestionModel.class_id {
                
                //满足条件上传问题
                sendQusetionToServer()
                
            } else {
                
                YNProgressHUD().showText("请选择品类", toView: self.view)
            }
            
            
        } else {
            
            YNProgressHUD().showText("请填写问题描述", toView: self.view)
        }
    
        
    }
    
    //MARK: Http send 
    func sendQusetionToServer() {
        
        let action = self.isOfflineQuestion ? "addOfflineQuestion" : "addQuestion"
        
        //还没有加图片  然后测试
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": action,
            "user_id": self.askQuestionModel.user_id,
            "descript": self.askQuestionModel.descript,
            "class_id": self.askQuestionModel.class_id,
            "latitude": self.askQuestionModel.latitude,
            "longitude": self.askQuestionModel.longitude,
            "address_detail": self.askQuestionModel.address_detail,
            "address": self.askQuestionModel.address
        ]
        
        sendImagesToServer(params)
        
    }
    
    func sendImagesToServer(params: [String: String?]) {
    
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpAskQuestion().sendQuestionToServerWithParams(params, files: self.uploadImageFilesArray, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            //print(json)
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    YNProgressHUD().showText("提问成功", toView: self.view)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        
                        //退出控制器
                        if self.navigationController?.viewControllers.count <= 1 {
                            
                            self.dismissViewControllerAnimated(true) { () -> Void in
                                
                                
                            }
                            
                        } else {
                            
                            self.navigationController?.popViewControllerAnimated(true)
                            
                        }
                        
                    }
                    
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
//                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
        
            return CGSizeMake(self.view.frame.size.width, 150)
            
        } else if indexPath.section == 2 || indexPath.section == 3{
        
            return CGSizeMake(self.view.frame.size.width, 50)
            
        } else if indexPath.section == 4 {
        
            return CGSizeMake(self.view.frame.size.width, 200)
        }
        
        let widthHeight = (self.view.frame.size.width - 2*6) / 3 - 1
        
        return CGSizeMake(widthHeight, widthHeight)
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 5
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
            return cell
            
        } else if indexPath.section == 2 {
        
            let identify = "Cell_Ask_Qustion_Location"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionLocationCollectionViewCell
            
            //TODO: 有时间的话给品类做一个图标
            cell.imageName = nil
            cell.title = "选择品类"
            cell.detaileTitle = self.category
            cell.isShowRightError = true
            return cell
            
        } else if indexPath.section == 3 {
        
            let identify = "Cell_Ask_Qustion_Location"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionLocationCollectionViewCell
            cell.imageName = "home_ask_question_location"
            cell.title = "当前地址"
            cell.detaileTitle = self.locationDetail
            cell.isShowRightError = false
            
            return cell
            
        } else if indexPath.section == 4 {
        
            //提问说明
            let identify = "Cell_Ask_Qustion_explain"
            
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionExplianCollectionCell
            
            cell.explainLabel.text = self.explainText
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
    
    //MARK:UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
        
            //选择标签
            let selectCatagoryVc = YNSelectedCategoryViewController()
            selectCatagoryVc.delegate = self
            self.navigationController?.pushViewController(selectCatagoryVc, animated: true)
        }
        
    }
    
    //MARK: YNAskQuestionTextCollectionViewCellDelegate
    func askQuestionTextCollectionViewCellTextViewDidEndEditing(text: String) {
        
        self.askQuestionModel.descript = text
    
    }
    
    
    //MARK: YNSelectedCategoryViewControllerDelegate
    func selectedCategoryDidSelectedProduct(product: YNCategoryModel) {
        self.askQuestionModel.class_id = product.id
        self.category = product.class_name
        
        self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 2)])
        
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
    
    //MARK: LocationDelegate
    func locationDidUpdateLocation(location: CLLocation) {
        
        //解析地址
        geocoderAddress(location)
    }

    //MARK: 解析地址
    func geocoderAddress(location: CLLocation) {
        
        self.location.geocoderAddress(location, success: { (placemarks) -> Void in
            
            if let _ = placemarks {
                
                let placeMark: CLPlacemark = placemarks!.first!
                
                var address = ""
                
                if let _ = placeMark.administrativeArea {
                
                    address += placeMark.administrativeArea!
                    
                }
                
                if let _ = placeMark.locality {
                
                    address += placeMark.locality!
                }
                
                if let _ = placeMark.subLocality {
                
                    address += placeMark.subLocality!
                }
                
                if kIOS7() {
                
                    if let _ = placeMark.name {
                    
//                        address += placeMark.name!
                        
                        self.locationDetail = placeMark.name!
                        
                    }
                    
                } else {
                
                    if let _ = placeMark.thoroughfare {
                    
//                        address += placeMark.thoroughfare!
                        self.locationDetail = placeMark.thoroughfare!
                    }
                }

                //构造上传地址，精度，纬度和地址
                self.askQuestionModel.latitude = String(location.coordinate.latitude)
                self.askQuestionModel.longitude = String(location.coordinate.longitude)
                self.askQuestionModel.address_detail = self.locationDetail
                self.askQuestionModel.address = address
            }
            
            
            }) { (error) -> Void in
                
//                print(error)
                var address = ""
                address += "定位失败"
                self.locationDetail = address
        }

    
    }

    //MARK: property
    let location = Location()
    
    let finishViewHeight: CGFloat = 40
    var finishView: YNFinishInputView?
    
    var askQuestionModel = YNAskQuestionModel()
    
    //品类
    var category: String? {
        
        didSet {
            
            if let _ = category {
                
                self.collectionView.reloadSections(NSIndexSet(index: 2))
            }
        }
    }
    
    //定位到的地址
    var locationDetail: String? {
        
        didSet {
            
            if let _ = locationDetail {
                
                self.collectionView.reloadSections(NSIndexSet(index: 3))
            }
        }
    }
    
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
    
    
    //提示文字
    let explainText = "【提问注意事项】\n1.标本选取要有代表性;\n2.明确地区和品种;\n3.说明是露地种植还是大棚种植;\n4.说明最近天气情况和墒情;\n5.列举最近用药用肥品种;\n6.描述最近农事操作;\n7.需要图片的请至少提供一张标本局部特写照片，一张受害全景照片，最好一张光学显微镜下的病原菌照片;\n8.详细描述受害状况."
    
}
