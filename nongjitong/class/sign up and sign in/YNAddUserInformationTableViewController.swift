//
//  YNAddUserInformationTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/5.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddUserInformationTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YNFinishInputViewDelegate {
    
    //添加一个随键盘弹出的view
    var finishView: YNFinishInputView?
    let finishViewHeight: CGFloat = 40
    
    //头像
    @IBOutlet weak var avatorImage: UIImageView!
    //昵称
    @IBOutlet weak var nickNameTextFiled: UITextField!
    //姓名
    @IBOutlet weak var trueNameTextFiled: UITextField!
    //身份证号
    @IBOutlet weak var idNunberTextFiled: UITextField!
    //角色
    @IBOutlet weak var roleTextFiled: UITextField!
    //地区
    @IBOutlet weak var areaTextFiled: UITextField!
    //手机号
    @IBOutlet weak var mobileLabel: UILabel!
    //性别
    @IBOutlet weak var genderTextFiled: UITextField!
    
    var imageData: NSData?
    
    var roleId: String?
    var genderId: String?
    var city: YNBaseModel? {
    
        didSet {
        
            self.areaTextFiled.text = city?.name
        }
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        //设置电话号码
        self.mobileLabel.text = kUser_MobileNumber() as? String
        
        addViewWithKeyBoard()
    }
    
    func addViewWithKeyBoard() {
    
        //添加跟随键盘出现的View
        addFinishView()
        
        //添加键盘通知
        addKeyBoardNotication()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self.finishView!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.finishView?.removeFromSuperview()
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addFinishView() {
        
        let finishView = YNFinishInputView()
        finishView.delegate = self
        finishView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, finishViewHeight)
        self.finishView = finishView
        
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
    
    
    
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            
            self.view.endEditing(true)
            //打开相册或相机选择头像
            selectAlbumOrCamera()
            
        } else if indexPath.row == 4 {
            
            self.view.endEditing(true)
            //选择身份
            chooseWorker()
            
        } else if indexPath.row == 5 {
            
            self.view.endEditing(true)
            //选择地区
            
            let rootstoryboardVc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Segue_Province") as! YNProvinceTableViewController
            
            self.navigationController?.pushViewController(rootstoryboardVc, animated: true)
            
        } else if indexPath.row == 7 {
            
            self.view.endEditing(true)
            //选择性别
            chooseGender()
            
        }
        
        
    }
    
    //MARK: - 选择性别
    func chooseGender() {
        
        if #available(iOS 8.0, *) {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            //取消按钮
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            })
            alertController.addAction(cancleAction)
            
            let albumAction = UIAlertAction(title: "男", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.genderTextFiled.text = "男"
                self.genderId = "1"
            })
            alertController.addAction(albumAction)
            
            let cameraAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.genderTextFiled.text = "女"
                self.genderId = "0"
                
            })
            alertController.addAction(cameraAction)
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                
            })
            
            
        } else {
            
            // Fallback on earlier versions iOS7
            
            genderActionSheetInIOS8Early()
            
        }
        
        
    }
    func genderActionSheetInIOS8Early() {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        actionSheet.tag = 2
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("男")
        actionSheet.addButtonWithTitle("女")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.showInView(self.view)
        
    }
    
    //MARK: - 选择身份
    func chooseWorker() {
        
        if #available(iOS 8.0, *) {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            //取消按钮
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            })
            alertController.addAction(cancleAction)
            
            let oneAction = UIAlertAction(title: "生产者", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleTextFiled.text = "生产者"
                self.roleId = "1"
            })
            alertController.addAction(oneAction)
            
            let twoAction = UIAlertAction(title: "农技师", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleTextFiled.text = "农技师"
                self.roleId = "2"
            })
            alertController.addAction(twoAction)
            
            let threeAction = UIAlertAction(title: "农资厂家业务员", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleTextFiled.text = "农资厂家业务员"
                self.roleId = "3"
            })
            alertController.addAction(threeAction)
            
            let fourAction = UIAlertAction(title: "农资批发商", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleTextFiled.text = "农资批发商"
                self.roleId = "4"
            })
            alertController.addAction(fourAction)
            
            let fiveAction = UIAlertAction(title: "农资零售商", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleTextFiled.text = "农资零售商"
                self.roleId = "5"
                
            })
            alertController.addAction(fiveAction)
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                
            })
            
            
        } else {
            
            // Fallback on earlier versions iOS7
            
            chooseRoleActionSheetInIOS8Early()
            
        }
        
        
    }
    
    func chooseRoleActionSheetInIOS8Early() {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        actionSheet.tag = 3
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("生产者")
        actionSheet.addButtonWithTitle("农技师")
        actionSheet.addButtonWithTitle("农资厂家业务员")
        actionSheet.addButtonWithTitle("农资批发商")
        actionSheet.addButtonWithTitle("农资零售商")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 5
        actionSheet.showInView(self.view)
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
    
    //MARK: - iOS8以前actionsheet
    func actionsheetInIOS8Early() {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        actionSheet.tag = 1
        
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
        
        if actionSheet.tag == 1 {
            
            if buttonIndex == 0 {
                //相册
                self.openAlbum(UIImagePickerControllerSourceType.PhotoLibrary)
                
            } else if buttonIndex == 1 {
                //相机
                self.openAlbum(UIImagePickerControllerSourceType.Camera)
            }
            
        } else if actionSheet.tag == 2 {
            
            //性别
            if buttonIndex == 0 {
                //男1
                
                self.genderTextFiled.text = "男"
                self.genderId = "1"
                
            } else if buttonIndex == 1{
                //女0
                self.genderTextFiled.text = "女"
                self.genderId = "0"
            }
            
            
        } else if actionSheet.tag == 3 {
            
            //TODO: 身份
            switch buttonIndex {
                
            case 0:
                self.roleTextFiled.text = "生产者"
                self.roleId = "1"
            case 1:
                self.roleTextFiled.text = "农技师"
                self.roleId = "2"
            case 2:
                self.roleTextFiled.text = "农资厂家业务员"
                self.roleId = "3"
            case 3:
                self.roleTextFiled.text = "农资批发商"
                self.roleId = "4"
            case 4:
                self.roleTextFiled.text = "农资零售商"
                self.roleId = "5"
            default:
                print("没有角色")
                
            }
            
            
        }
        
        
    }

    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //        print("\ndidFinishPickingMediaWithInfo - \(info)\n")
        
        let mediaType = info["UIImagePickerControllerMediaType"] as! String
        
        if mediaType == "public.image" {
            //图片
            
            let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
            
            self.imageData = UIImageJPEGRepresentation(image, 0.001)
            self.avatorImage.image = image
            
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
        
            
        } else {
            
            //不是图片
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            //TODO: - 给个不是图片的提示
            
        }
        
    }
    
    //MARK: event response
    @IBAction func doneButtonDidClick(sender: AnyObject) {
        
        let nicename = nickNameTextFiled.text
        
        print(nicename)
        
        if nickNameTextFiled.text == "" {
            
            YNProgressHUD().showText("请填写昵称", toView: self.view)
            
        } else if roleTextFiled.text == "" {
            
            YNProgressHUD().showText("请选择身份", toView: self.view)
            
        } else if areaTextFiled.text == "" {
            
            YNProgressHUD().showText("请选择地区", toView: self.view)
            
        }  else if mobileLabel.text == "" {
            
            YNProgressHUD().showText("请填写手机号", toView: self.view)
            
        } else {
            
            //上传信息
            uploadUserInformation()
            
        }

    }
    
    //上传用户信息
    func uploadUserInformation() {
        
        var truename = ""
        var sex = ""
        var id_num = ""
        
        if let _ = self.trueNameTextFiled.text {
        
            truename = self.trueNameTextFiled.text!
        }
    
        if let _ = self.genderId {
        
            sex = self.genderId!
        }
        
        if let _ = self.idNunberTextFiled.text {
        
            id_num = self.idNunberTextFiled.text!
        }
        
        let userId = kUser_ID() as? String
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "User",
            "a": "update",
            "id": userId,
            "nickname": self.nickNameTextFiled.text,
            "area_id": self.city?.id,
            "role_id": self.roleId,
            "truename": truename,
            "sex": sex,
            "id_num": id_num
        ]
        
        var files = [File]()
        
        if let tempImage = self.imageData {
            
//            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("1.jpg")
//            
//            //        print(path)
//            
//            tempImage.writeToFile(path!, atomically: true)
//            let imageUrl = NSURL(fileURLWithPath: path!)

            files.append(File(name: "avatar", imageData: tempImage))
        }
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpTool().updateUserAllInfoemations(params, files: files, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
    
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    if let _ = self.imageData {
                    
                        self.avatorImage.image = UIImage(data: self.imageData!)
                    }
                    
                    let msg = json["msg"] as! String
                    
                    //#warning: msg是更新成功 不是登陆成功
                    print("\n \(msg) \n")
                    
                    Tools().saveValue("YES", forKey: kUserIsInformationFinish)
                    Tools().saveValue(self.nickNameTextFiled.text, forKey: kUserNiceName)
                    
                    YNExchangeRootController().showHome()
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: UIApplication.sharedApplication().keyWindow!)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
        
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("请求失败", toView: UIApplication.sharedApplication().keyWindow!)
        }
    }
    
}
