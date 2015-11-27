//
//  YNPersionalSettingTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//个人设置

import UIKit

class YNPersionalSettingTableViewController: UITableViewController, YNModifytextViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - public proporty
    var cityName: String? {
    
        didSet {
        
            self.areaIDLabel.text = cityName
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

    
    var information: YNUserInformationModel? {
    
        didSet {
        
            self.setUserInformationData(information!)
        
        }
        
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.avatorImageView.layer.cornerRadius = 3
        self.avatorImageView.clipsToBounds = true
        
        //设置空白的界面数据
        self.setEmptyInterfaceData()
        //从服务器获取数据，设置界面数据
        loadDataFromServer()
    
    }
    
    //MARK: 获取用户信息
    func loadDataFromServer() {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpTool().getUserInformation({ (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let dict = json["data"] as! NSDictionary
                
//                    print(dict)
                    
                    let tempInfo = YNUserInformationModel(dict: dict)
                    
                    self.information = tempInfo
                    
                     //获取地区信息
                    self.loadCityData()
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
              progress.hideUsingAnimation()
              YNProgressHUD().showText("请求失败", toView: self.view)
                
        }
        
    }
    
    
    //MARK: 获取地区信息
    func loadCityData() {
    
        YNHttpGetCityTool().getAreaWithId(self.information!.area_id, successFull: { (json) -> Void in
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let dict = json["data"] as! NSDictionary
                    
//                    print(dict)
                    
                    let city = dict["city_name"] as! String
                    
                    self.areaIDLabel.text = city
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }

            
            }) { (error) -> Void in
                
                
        }
    }
    
    //MARK: - private method
    //MARK: 设置有数据时的页面
    func setUserInformationData(data: YNUserInformationModel) {
        
        self.nicenameLabel.text = data.nickname
        self.areaIDLabel.text = data.area_id
        self.mobelLabel.text = data.mobile
        self.trueNameLabel.text = data.truename
        self.idNumberLabel.text = data.id_num
        
        let imagedata = NSData(contentsOfURL: NSURL(string: data.avatar!)!)
        
        self.avatorImageView.image = UIImage(data: imagedata!)
        
//        if data.avatar?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
//        
//            Network.getImageWithURL(data.avatar!, success: { (data) -> Void in
//                
//                self.avatorImageView.image = UIImage(data: data)
//                
//            })
//            
//        }
        
        if data.sex == "0" {
        
            self.genderLabel.text = "女"
        } else {
        
            self.genderLabel.text = "男"
        }
        
        switch data.role_id {
            
        case "0":
            self.roleIDLabel.text = "生产者"
            
        case "1":
            self.roleIDLabel.text = "农技师"
           
        case "2":
            self.roleIDLabel.text = "农资厂家业务员"
            
        case "3":
            self.roleIDLabel.text = "农资批发商"
            
        case "5":
            self.roleIDLabel.text = "农资零售商"
            
        default:
            print("没有角色")
        }
        
        
        
    }
    
    //MARK: 设置没有数据使得页面
    func setEmptyInterfaceData() {
    
        self.nicenameLabel.text = ""
        self.roleIDLabel.text = ""
        self.areaIDLabel.text = ""
        self.mobelLabel.text = kUser_MobileNumber() as? String
        self.trueNameLabel.text = ""
        self.genderLabel.text = ""
        self.idNumberLabel.text = ""
        
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
                
                self.roleIDLabel.text = "生产者"
                //上传身份
                
                self.sendWorkerToServerWithID("1")
                
            })
            alertController.addAction(oneAction)
            
            let twoAction = UIAlertAction(title: "农技师", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleIDLabel.text = "农技师"
                //上传身份
                self.sendWorkerToServerWithID("2")
                
            })
            alertController.addAction(twoAction)
            
            let threeAction = UIAlertAction(title: "农资厂家业务员", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleIDLabel.text = "农资厂家业务员"
                //上传身份
                self.sendWorkerToServerWithID("3")
                
            })
            alertController.addAction(threeAction)
            
            let fourAction = UIAlertAction(title: "农资批发商", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                //上传身份
                self.sendWorkerToServerWithID("4")
            })
            alertController.addAction(fourAction)
            
            let fiveAction = UIAlertAction(title: "农资零售商", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.roleIDLabel.text = "农资零售商"
                //上传身份
                self.sendWorkerToServerWithID("5")
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
        actionSheet.addButtonWithTitle("生产者")
        actionSheet.addButtonWithTitle("农技师")
        actionSheet.addButtonWithTitle("农资厂家业务员")
        actionSheet.addButtonWithTitle("农资批发商")
        actionSheet.addButtonWithTitle("农资零售商")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 5
        actionSheet.showInView(self.view)
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
                //上传性别
                self.sendGenderToServerWithID("1")
                
            })
            alertController.addAction(albumAction)
        
            let cameraAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    
                self.genderLabel.text = "女"
                //上传性别
                self.sendGenderToServerWithID("0")
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
    
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        actionSheet.tag = 1
        actionSheet.delegate = self
        
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
    
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if actionSheet.tag == 1 {
            
            //相册或相机
            if buttonIndex == 0 {
                //相册
                self.openAlbum(UIImagePickerControllerSourceType.PhotoLibrary)
                
            } else if buttonIndex == 1{
                //相机
                self.openAlbum(UIImagePickerControllerSourceType.Camera)
            }
            
        } else if actionSheet.tag == 2 {
            
            //性别
            if buttonIndex == 0 {
                //男1
                
                self.genderLabel.text = "男"
                //上传性别
                self.sendGenderToServerWithID("1")
                
            } else if buttonIndex == 1{
                //女0
                
                 self.genderLabel.text = "女"
                //上传性别
                self.sendGenderToServerWithID("0")
            }
            
        
        } else if actionSheet.tag == 3 {
        
            //TODO: 身份
            
            var roleID = ""
            
            switch buttonIndex {
            
            case 0:
                self.roleIDLabel.text = "生产者"
                roleID = "1"
            case 1:
                self.roleIDLabel.text = "农技师"
                roleID = "2"
            case 2:
                self.roleIDLabel.text = "农资厂家业务员"
                roleID = "3"
            case 3:
                self.roleIDLabel.text = "农资批发商"
                roleID = "4"
            case 4:
                self.roleIDLabel.text = "农资零售商"
                roleID = "5"
            default:
                print("没有角色")
                
            }
            
            self.sendWorkerToServerWithID(roleID)
        }
        

    }
    
    //MARK: 上传性别
    func sendGenderToServerWithID(id: String) {
    
        let dict = ["paraName": "sex",
            "text": id]
        self.sendInformationToServer(dict)
    }
    
    //MARK: 上传身份
    func sendWorkerToServerWithID(id: String) {
        
        let dict = ["paraName": "role_id",
            "text": id]
        self.sendInformationToServer(dict)
    }
    
    func sendInformationToServer(dict: [String: String]) {

        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpTool().updateUserInformationText(dict, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let msg = json["msg"] as! String
                    
                    //#warning: msg是更新成功 不是登陆成功
                    print("\n \(msg) \n")
                    
//                    YNProgressHUD().showText(msg, toView: self.view)

                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
               
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
                
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
            
            //向服务器上传头像
            
            let imageData = UIImageJPEGRepresentation(image, 0.001)
            
            sendImageToServer(imageData!)
            
             //MARK: - 上传成功改变该页面的头像
            self.avatorImageView.image = image
            
        } else {
        
            //不是图片
            picker.dismissViewControllerAnimated(true) { () -> Void in
                
            }
            
            //TODO: - 给个不是图片的提示
            
        }
    
        
    }
    
    //MARK: 上传头像
    func sendImageToServer(imagedata: NSData) {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("1.jpg")
        
//        print(path)
        
        imagedata.writeToFile(path!, atomically: true)
        let imageUrl = NSURL(fileURLWithPath: path!)
        
        var files = [File]()
        files.append(File(name: "avatar", url: imageUrl))
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpTool().updataUserAvatorImage(files, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let msg = json["msg"] as! String
                    
                    YNProgressHUD().showText(msg, toView: self.view)
                    
                    //#warning: msg是更新成功 不是登陆成功
//                    print("\n \(msg) \n")
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                 progress.hideUsingAnimation()
                
                YNProgressHUD().showText("上传失败", toView: UIApplication.sharedApplication().keyWindow!)
                
        }
        
    
        
    }
    
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
            
        }
        
        
//        else if segue.identifier == "Segue_Province" {
//            
//            let destinationVc = segue.destinationViewController as! YNProvinceTableViewController
////            destinationVc.data = cityData
//            
//        }

        
    }
    
    
//    let cityData: Array<YNCityModel> = {
//        
//        let path = NSBundle.mainBundle().pathForResource("cityData", ofType: "plist")
//        
//        //转成plist
//        let temparray = NSArray(contentsOfFile: path!)
//        
//        var tempCityArray = [YNCityModel]()
//        
//        for item in temparray! {
//            
//            let citymodel = YNCityModel(dict: item as! NSDictionary)
//            tempCityArray.append(citymodel)
//        }
//    
//        return tempCityArray
//        
//        }()
}
