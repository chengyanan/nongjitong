//
//  YNSecondSearchViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/15.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNSecondSearchViewController: UIViewController, UISearchBarDelegate, YNFinishInputViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let finishViewHeight: CGFloat = 40
    
    //添加一个随键盘弹出的view
    var finishView: YNFinishInputView?
    
    var searchBar: UISearchBar = {
    
        let tempView = UISearchBar()
        tempView.placeholder = "请输入关键词"
        return tempView
    }()
    
    //tableViewCatagory数据源
    var cayegoryArray = [YNSearchCatagoryModel]()
    
    //tableViewProduct数据源
    var productArray = [YNSearchCatagoryModel]()
    
    var tableViewCatagory: UITableView?
    var tableViewProduct: UITableView?
    let tableViewCatagoryWidthPercent: CGFloat = 0.45
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.searchBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 44)
        self.searchBar.delegate = self

        self.view.addSubview(self.searchBar)

        addViewWithKeyBoard()
        setTableViewCatagory()
        setTableViewProduct()
        
        //加载选项数据
//        loadHttpData("0", reloadData: .tableViewCatagory)
        
        getCategoryFromServer("0", reloadData: .tableViewCatagory)
        
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

    //MARK: event response
    @IBAction func leftItemClick(sender: AnyObject) {
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
        
    }
    
    
    func setTableViewCatagory() {
        
        //tableViewCatagory
        let Y = self.finishViewHeight + 64 + 2
        let width = self.view.frame.size.width * tableViewCatagoryWidthPercent
        let height = self.view.frame.size.height - Y - 49
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.frame = CGRectMake(0, Y, width, height)
    
        tempTableView.tag = 1
        self.view.addSubview(tempTableView)
        self.tableViewCatagory = tempTableView
        
    }
    
    func setTableViewProduct() {
        
        //tableViewProduct
        let x = self.view.frame.size.width * tableViewCatagoryWidthPercent
        let width = self.view.frame.size.width - x
        let Y = self.finishViewHeight + 64 + 2
        let height = self.view.frame.size.height - Y - 49
        
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.frame = CGRectMake(x, Y, width, height)
        
        tempTableView.tag = 2

        self.view.addSubview(tempTableView)
        self.tableViewProduct = tempTableView
        

    }
    
    
    func addViewWithKeyBoard() {
        
        //添加跟随键盘出现的View
        addFinishView()
        
        //添加键盘通知
        addKeyBoardNotication()
    }
    
    func addFinishView() {
        
        let finishView = YNFinishInputView()
        finishView.delegate = self
        finishView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, finishViewHeight)
        self.finishView = finishView
        
    }
    
    func addKeyBoardNotication() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK:UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let text = searchBar.text where text != "" {
            
            let resaultController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SB_Search_Resault") as! YNSearchViewController
            
            resaultController.searchText = searchBar.text!
            
            self.navigationController?.pushViewController(resaultController, animated: true)
            
            searchBar.text = ""
            self.searchBar.endEditing(true)
        }
        
        
    }
    
    //MARK: YNFinishInputViewDelegate
    func finishInputViewFinishButtonDidClick() {
        
        self.searchBar.text = ""
        
        //退出键盘
        hideKeyBoard()
    }
    
    func hideKeyBoard() {
        
        self.view.endEditing(true)
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
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            return self.cayegoryArray.count
            
        } else if tableView.tag == 2 {
            
            return self.productArray.count
        }
        
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            
            let identify = "Cell_Catagory"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNCategoryTableViewCell
            
            if cell == nil {
                
                cell = YNCategoryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            }
            
//            cell?.categoryModel = self.cayegoryArray[indexPath.row]
            cell?.searchCategoryModel = self.cayegoryArray[indexPath.row]
            
            return cell!
        }
        
        let identify = "Cell_Catagory"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNCategoryTableViewCell
        
        if cell == nil {
            
            cell = YNCategoryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
//        cell?.categoryModel = self.productArray[indexPath.row]
        cell?.searchCategoryModel = self.productArray[indexPath.row]
        cell?.nameLabel.textColor = UIColor.blackColor()
        cell?.backgroundColor = UIColor.whiteColor()
        
        return cell!
        
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == 1 {
            
            let model = self.cayegoryArray[indexPath.row]
            model.isSelected = true
            
            self.tableViewCatagory?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            self.tableViewCatagory?.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            
            //发送网络请求二级数据
//            loadHttpData(model.cid!, reloadData: .tableViewProduct)
            getCategoryFromServer(model.cid!, reloadData: .tableViewProduct)
            
        } else {
        
            
            let model = self.productArray[indexPath.row]
            
            let vc = YNDocNameListViewController()
            vc.cid = model.cid
           
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == 1 {
            
            self.cayegoryArray[indexPath.row].isSelected = false
            self.tableViewCatagory?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            
        }
        
    }
    
    //MARK: 加载网络数据
    
    func getCategoryFromServer(parentId: String, reloadData: YNReloadDataType) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Search",
            "a": "getCategory",
            "parent_id": parentId
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            //            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let resaultData = json["data"] as! NSArray
                    
                    if resaultData.count > 0 {
                        
                        
                        if reloadData == .tableViewCatagory {
                            
                            for var i = 0; i < resaultData.count; i++ {
                                
                                let model = YNSearchCatagoryModel(dict: resaultData[i] as! NSDictionary)
                                
                                self.cayegoryArray.append(model)
                            }
                            
                            self.tableViewCatagory!.reloadData()
                            self.tableView(self.tableViewCatagory!, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                            
                        } else if reloadData == .tableViewProduct {
                            
                            self.productArray = [YNSearchCatagoryModel]()
                            
                            for item in resaultData {
                                
                                let model = YNSearchCatagoryModel(dict: item as! NSDictionary)
                                self.productArray.append(model)
                                
                            }
                            
                            //                        //把选中的做上标记
                            //                        self.markSelected()
                            
                            self.tableViewProduct!.reloadData()
                        }
                        
                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("该分类下暂时还没有数据", toView: self.view)
                        
                        if reloadData == .tableViewProduct {
                            
                            self.productArray = [YNSearchCatagoryModel]()
                            
                            self.tableViewProduct!.reloadData()
                        }
                        
                        
                        
                    }
                    
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
   

    
    
}
