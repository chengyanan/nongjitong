//
//  YNSearchViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/20.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNSearchViewControllerDelegate {

    func searchViewControllerDidSelectRowAtIndexPath(model: YNSearchResaultModel)
}

class YNSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var isSearchResault = true
    
    var model: YNSearchCatagoryModel? {
    
        didSet {
        
            //MARK: 加载搜索结果
            search()
        }
    }
    
    var delegate: YNSearchViewControllerDelegate?
    
//    let finishViewHeight: CGFloat = 40
    
    //MARK: - private proporty
    @IBOutlet weak var tableView: UITableView!
    
    var indexRow = 0
    
    var searchText = "" {
        
        didSet {
            
            if searchText != "" {
                
                self.page = 1
                self.tempResaultArray = [YNSearchResaultModel]()
                
                //MARK: 加载搜索结果
                search()
            }
        }
    }
    
    
    var page: Int = 1
    var pagecount: Int = 20
    
    var tempResaultArray = [YNSearchResaultModel]()
    var resaultArray: Array<YNSearchResaultModel>? {
    
        didSet {
        
            self.tableView.reloadData()
            
        }
    
    }
    
    //MARK: - life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相关文章"
        
//        self.searchBar.delegate = self
//        self.navigationItem.titleView = self.searchBar
        
        self.tableView.delegate = self
        self.tableView.hidden = true
        self.tableView.allowsSelection = true
        self.tableView.showsVerticalScrollIndicator = false
        
//        addViewWithKeyBoard()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.view.endEditing(true)
//        
//        UIApplication.sharedApplication().keyWindow?.addSubview(self.finishView!)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        self.finishView?.removeFromSuperview()
//    }
    
    //MARK: event response    
    @IBAction func leftBarButtonClick(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
    }
    
//    func addViewWithKeyBoard() {
//        
//        //添加跟随键盘出现的View
//        addFinishView()
//        
//        //添加键盘通知
//        addKeyBoardNotication()
//    }
//    
//    func addFinishView() {
//        
//        let finishView = YNFinishInputView()
//        finishView.delegate = self
//        finishView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, finishViewHeight)
//        self.finishView = finishView
//        
//    }
//    
//    func addKeyBoardNotication() {
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let userInfo = notification.userInfo {
//            
//            let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//            
//            //            print(keyboardBounds)
//            
//            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//            
//            let keyboardBoundsRect = self.view.convertRect(keyboardBounds, toView: nil)
//            
//            let deltaY = keyboardBoundsRect.size.height + finishViewHeight
//            
//            let animations: (()->Void) = {
//                
//                self.finishView!.transform = CGAffineTransformMakeTranslation(0, -deltaY)
//            }
//            
//            if duration > 0 {
//                
//                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
//                
//                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
//                
//            } else {
//                
//                animations()
//            }
//            
//            
//        }
//        
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        
//        if let userInfo = notification.userInfo {
//            
//            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//            let animations:(() -> Void) = {
//                
//                self.finishView!.transform = CGAffineTransformIdentity
//            }
//            
//            if duration > 0 {
//                
//                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
//                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
//                
//            } else{
//                
//                animations()
//            }
//        }
//        
//    }
//    
//    //MARK: YNFinishInputViewDelegate
//    func finishInputViewFinishButtonDidClick() {
//        //退出键盘
//        hideKeyBoard()
//    }
//    func hideKeyBoard() {
//    
//        self.searchBar.endEditing(true)
//    }

    
    //MARK: - UISearchBarDelegate
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        
//        self.searchBar.endEditing(true)
//        self.page = 1
//        self.tempResaultArray = [YNSearchResaultModel]()
//        
//        //MARK: 加载搜索结果
//        search()
//    }
    
    
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        
//        self.searchBar.text = nil
//        self.resaultArray = [YNSearchResaultModel]()
//    }
    
    func search() {
        
        let params: [String: String?]
        
        if isSearchResault {
            //搜索结果(默认)
            params = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "Search",
                "a": "search",
                "keyword": self.searchText,
                "page": String(page),
                "pagecount": "\(pagecount)"
            ]
            
        } else {
        
            //相关文章列表
            params = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "Search",
                "a": "getCatDocs",
                "cid": model?.cid,
                "page": String(page),
                "page_size": "\(pagecount)"
            ]
            
        }
        
            let progress = YNProgressHUD().showWaitingToView(self.view)
            
            Network.post(kURL, params: params, success: { (data, response, error) -> Void in
                
                progress.hideUsingAnimation()
                
                let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
//                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let resaultData = json["data"] as! NSArray
                        if resaultData.count > 0 {
                        
                            self.tableView.hidden = false
                            for item in resaultData {
                            
                                let dict = item as! NSDictionary
                                
                                let resaultModel = YNSearchResaultModel(dict: dict)
                                
                                self.tempResaultArray.append(resaultModel)
                            }
                        
                            self.resaultArray = self.tempResaultArray
                            
                        } else {
                        
                            //没数据
                            YNProgressHUD().showText("没有数据啦", toView: self.view)
                            
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
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tempArray = self.resaultArray {
        
            if tempArray.count < 20 {
            
                return tempArray.count
                
            } else {
            
                return tempArray.count + 1
            }
           
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == self.resaultArray?.count {
        
            return 50
        }
        
        return 94
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.resaultArray?.count {
        
            let identify: String = "Cell_Resault_LoadMore"
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                
            }
            
            return cell!
        
        }
        
        let identify: String = "Cell_Search_Resault"
        var cell: YNSearchResaultCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchResaultCell
        
        if cell == nil {
            
            cell = YNSearchResaultCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            
        }
        
        cell?.resault = self.resaultArray![indexPath.row]
        
        return cell!

    }
    
//    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == self.resaultArray?.count {
        
            loadMore()
        
        } else {
        
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyBoard.instantiateViewControllerWithIdentifier("SB_Resault_Details") as! YNSearchResaultDetailViewController
            
            vc.searchresault = self.resaultArray![indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
            
            
//            if self.isSearchResault {
//            
//                //MARK: 通知代理跳到详情页面
//                let model = self.resaultArray![indexPath.row]
//                self.delegate?.searchViewControllerDidSelectRowAtIndexPath(model)
//                
//            } else {
//            
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                
//                let vc = storyBoard.instantiateViewControllerWithIdentifier("SB_Resault_Details") as! YNSearchResaultDetailViewController
//                
//                vc.searchresault = self.resaultArray![indexPath.row]
//                
//                navigationController?.pushViewController(vc, animated: true)
//            }
            
            
        }
        
        
    }
    
    func loadMore() {
    
        self.page++
        self.search()
        
    }
    
    
//    //MARK: - prepare segue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        
//        if segue.identifier == "Segue_SearchResault_Detail" {
//        
//            //传递数据
//            let vc = segue.destinationViewController as? YNSearchResaultDetailViewController
//    
//            vc?.searchresault = self.resaultArray![indexRow]
//            
//        }
//        
//    }
    
    
//    //MARK: event response
//    @IBAction func cancleBarOtemClick(sender: AnyObject) {
//        
//        self.searchBar.endEditing(true)
//        self.searchBar.text = nil
//        self.resaultArray = [YNSearchResaultModel]()
//    }
    
//   
//    //添加一个随键盘弹出的view
//    var finishView: YNFinishInputView?
//    
//    let searchBar: UISearchBar = {
//        
//        let tempSearchBar = UISearchBar()
//        tempSearchBar.placeholder = "请输入关键词"
//        
//        for view in (tempSearchBar.subviews.last?.subviews)! {
//        
//            if view is UITextField {
//            
//                view.backgroundColor = UIColor(red: 221/255.0, green: 223/255.0, blue: 225/255.0, alpha: 1)
//            }
//            
//        }
//        return tempSearchBar
//        
//        }()
    
    
    
//    deinit {
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }

    
}
