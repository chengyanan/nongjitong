//
//  YNAddUserInformationTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/5.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAddUserInformationTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     //TODO: 添加一个随键盘弹出的view
    
    
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
    
    var roleId: String?
    var genderId: String?
    var cityName: String? {
    
        didSet {
        
            self.areaTextFiled.text = cityName
        }
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        //设置电话号码
        self.mobileLabel.text = kUser_MobileNumber() as? String
        
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
        
        if nickNameTextFiled.text == nil {
            
            YNProgressHUD().showText("请填写昵称", toView: self.view)
            
        } else if roleTextFiled.text == nil {
            
            YNProgressHUD().showText("请选择角色", toView: self.view)
            
        } else if areaTextFiled.text == nil {
            
            YNProgressHUD().showText("请选择地区", toView: self.view)
            
        }  else if mobileLabel.text == nil {
            
            YNProgressHUD().showText("请填写手机号", toView: self.view)
            
        } else {
            
            //TODO: 上传信息
    
            YNExchangeRootController().showHome()
            
        }

    }
    
    
    
}
