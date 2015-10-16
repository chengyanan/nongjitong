//
//  YNPersionalSettingTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNPersionalSettingTableViewController: UITableViewController, YNModifytextViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YNProvinceTableViewControllerDelegate {

    //MARK: - public proporty 
    
    var isFromMeVc: Bool? {
    
        didSet {
        
            if isFromMeVc! {
            
                //从个人资料界面转过来的
                self.rightBarButtonItem.enabled = false
                self.rightBarButtonItem.title = nil
                
                //从服务器获取数据，设置界面数据
                //TODO:从服务器获取数据，设置界面数据
            } else {
            
                //从登录界面转过来的
                self.rightBarButtonItem.enabled = false
                self.rightBarButtonItem.title = "完成"
                
                //设置空白的界面数据
                self.setEmptyInterfaceData()
                
            }
        
        }
    
    }
    
    
    //MARK: - private proporty
    //头像
    @IBOutlet weak var avatorImageView: UIImageView!
    //昵称
    @IBOutlet weak var nicenameLabel: UILabel!
    //角色ID
    @IBOutlet weak var roleIDLabel: UILabel!
    //地区ID
    @IBOutlet weak var areaIDLabel: UILabel!
    //手机号
    @IBOutlet weak var mobelLabel: UILabel!
    //姓名
    @IBOutlet weak var trueNameLabel: UILabel!
    //性别
    @IBOutlet weak var genderLabel: UILabel!
    //身份证号
    @IBOutlet weak var idNumberLabel: UILabel!
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.avatorImageView.layer.cornerRadius = 3
        self.avatorImageView.clipsToBounds = true
    }
    
    //MARK: - private method
    func setEmptyInterfaceData() {
    
        self.nicenameLabel.text = nil
        self.roleIDLabel.text = nil
        self.areaIDLabel.text = nil
        self.mobelLabel.text = kUser_MobileNumber() as? String
        self.trueNameLabel.text = nil
        self.genderLabel.text = nil
        self.idNumberLabel.text = nil
    }
    
    
    //MARK: - tableViewDataSource
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
            return 36
        }
        
        return 16
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    //MARK: - tableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
        
            if indexPath.row == 0 {
            
                //打开相册或相机选择头像
                
                selectAlbumOrCamera()
            }
        }
        
        if indexPath.section == 1 {
        
            if indexPath.row == 0 {
            
                //打开模态窗口选择身份
            
                chooseWorker()
                
            }
            
        }
        
        
        if indexPath.section == 2 {
        
            if indexPath.row == 1 {
            
                //显示actionseet 选择性别
            
                chooseGender()
                
            }
        
        }
        
        
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
    
    //MARK: - 选择身份
    func chooseWorker() {
    
        if #available(iOS 8.0, *) {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            //取消按钮
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            })
            alertController.addAction(cancleAction)
            
            let oneAction = UIAlertAction(title: "生产者", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                //TODO: - 上传身份
                //上传成功之后修改名字
                self.roleIDLabel.text = "生产者"
        
                
            })
            alertController.addAction(oneAction)
            
            let twoAction = UIAlertAction(title: "农技师", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleIDLabel.text = "农技师"
                
                //TODO: - 上传身份
            })
            alertController.addAction(twoAction)
            
            let threeAction = UIAlertAction(title: "农资厂家业务员", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                //TODO: - 上传身份
                
                self.roleIDLabel.text = "农资厂家业务员"
                
            })
            alertController.addAction(threeAction)
            
            let fourAction = UIAlertAction(title: "农资批发商", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleIDLabel.text = "农资批发商"
                //TODO: - 上传身份
            })
            alertController.addAction(fourAction)
            
            let fiveAction = UIAlertAction(title: "农资零售商", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleIDLabel.text = "农资零售商"
                //TODO: - 上传身份
            })
            alertController.addAction(fiveAction)
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                
            })
            
            
        } else {
            
            // Fallback on earlier versions iOS7
            
//            genderActionSheetInIOS8Early()
            
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
                
                self.genderLabel.text = "男"
                
            })
            alertController.addAction(albumAction)
        
            let cameraAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    
                self.genderLabel.text = "女"
                    
            })
            alertController.addAction(cameraAction)
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                
            })
            
            
        } else {
            
            // Fallback on earlier versions iOS7
            
            genderActionSheetInIOS8Early()
            
        }

    
    }
    
    //MARK: - iOS8以前actionsheet
    func actionsheetInIOS8Early() {
    
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.tag = 1
        actionSheet.delegate = self
        
        actionSheet.addButtonWithTitle("相册")
        
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera) {
            
            actionSheet.addButtonWithTitle("相机")
            
        }
        
        actionSheet.showInView(self.view)
    
    }
    
    func genderActionSheetInIOS8Early() {
    
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.tag = 2
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("男")
        actionSheet.addButtonWithTitle("女")
        actionSheet.showInView(self.view)
    
    }
    
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if actionSheet.tag == 1 {
        
            if buttonIndex == 0 {
                //相册
                
                self.openAlbum(UIImagePickerControllerSourceType.PhotoLibrary)
                
            } else {
                //相机
                
                self.openAlbum(UIImagePickerControllerSourceType.Camera)
            }
            
        } else if actionSheet.tag == 1 {
        
            
            if buttonIndex == 0 {
                //男
                
                self.genderLabel.text = "男"
                
            } else {
                //女
                
                 self.genderLabel.text = "女"
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
            
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            //TODO:向服务器上传头像
            
            
             //MARK: - 上传成功改变该页面的头像
            self.avatorImageView.image = image
            
        } else {
        
            //不是图片
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            //TODO: - 给个不是图片的提示
            
        }
    
        
    }
    
    //MARK: - UIActionSheetDelegate
    
    
    //MARK: - YNModifytextViewControllerDelegate
    func modifytextViewController(modifytextViewController: YNModifytextViewController, text: String?) {
        
        if modifytextViewController.textType == YNTextType.NiceName {
            
            //昵称
            
            self.nicenameLabel.text = text
            
        } else if modifytextViewController.textType == YNTextType.UserName {
            
            //姓名
            
            self.trueNameLabel.text = text
            
            
        } else if modifytextViewController.textType == YNTextType.IDNumber {
            
            //身份证号
            self.idNumberLabel.text = text
            
        } else if modifytextViewController.textType == YNTextType.MobileNumber {
            
            //号码
            
            self.mobelLabel.text = text
            
        }
        
        
    }
    
    //MARK: - YNProvinceTableViewControllerDelegate
    func provinceTableViewController(vc: YNProvinceTableViewController, province: YNBaseModel, city: YNBaseModel) {
        
        self.areaIDLabel.text = "\(province.name)  \(city.name)"
        
    }
    
    
    //MARK: - event response
    @IBAction func doneItemClick(sender: AnyObject) {
        
        if nicenameLabel.text == nil {
        
            YNProgressHUD().showText("请填写昵称", toView: self.view)
        
        } else if roleIDLabel.text == nil {
        
           YNProgressHUD().showText("请选择角色", toView: self.view)
            
        } else if areaIDLabel.text == nil {
        
            YNProgressHUD().showText("请选择地区", toView: self.view)
            
        }  else if mobelLabel.text == nil {
            
            YNProgressHUD().showText("请填写手机号", toView: self.view)
            
        } else {
        
        
            YNExchangeRootController().showHome()
        
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Segue_Nicename" {
        
            //昵称
            let destinationVc = segue.destinationViewController as! UINavigationController
           let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.NiceName
            rootVc.textString = self.nicenameLabel.text
            rootVc.delegate = self
            
        } else if segue.identifier == "Segue_name" {
            
            //姓名
            let destinationVc = segue.destinationViewController as! UINavigationController
            let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.UserName
            rootVc.textString = self.trueNameLabel.text
            rootVc.delegate = self

        } else if segue.identifier == "Segue_IdNumber" {
            
            //身份证号
            let destinationVc = segue.destinationViewController as! UINavigationController
            let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.IDNumber
            rootVc.textString = self.idNumberLabel.text
            rootVc.delegate = self

        } else if segue.identifier == "Segue_MobileNumber" {
            
            //手机号码
            let destinationVc = segue.destinationViewController as! UINavigationController
            let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.MobileNumber
            rootVc.textString = self.mobelLabel.text
            rootVc.delegate = self
            
        }  else if segue.identifier == "Segue_Province" {
            
            let destinationVc = segue.destinationViewController as! YNProvinceTableViewController
            destinationVc.data =
            destinationVc.delegate = self
            
        }

        
    }
    
    
    lazy let cityData: Array<YNCityModel> = {
        
        let path = NSBundle.mainBundle().pathForResource("cityData", ofType: "plist")
        
        //TODO: 转成plist
        
        
        }()
}
