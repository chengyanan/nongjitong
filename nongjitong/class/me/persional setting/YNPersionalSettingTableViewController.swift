//
//  YNPersionalSettingTableViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/8.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNPersionalSettingTableViewController: UITableViewController {

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
    
        
    }
    
    //MARK: - private method
    func setEmptyInterfaceData() {
    
        self.nicenameLabel.text = nil
        self.roleIDLabel.text = nil
        self.areaIDLabel.text = nil
        self.mobelLabel.text = kUser_MobileNumber() as? String
        self.trueNameLabel.text = nil
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
            }
        }
        
        if indexPath.section == 1 {
        
            if indexPath.row == 0 {
            
                //打开模态窗口选择身份
            
            }
            
        }
        
        
        if indexPath.section == 2 {
        
            if indexPath.row == 1 {
            
                //显示actionseet 选择性别
            
            }
        
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
        } else if segue.identifier == "Segue_name" {
            
            //姓名
            let destinationVc = segue.destinationViewController as! UINavigationController
            let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.UserName

        } else if segue.identifier == "Segue_IdNumber" {
            
            //身份证号
            let destinationVc = segue.destinationViewController as! UINavigationController
            let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.IDNumber

        } else if segue.identifier == "Segue_MobileNumber" {
            
            //手机号码
            let destinationVc = segue.destinationViewController as! UINavigationController
            let rootVc = destinationVc.viewControllers[0] as! YNModifytextViewController
            rootVc.textType = YNTextType.MobileNumber
            
        }
        
    }
    
}
