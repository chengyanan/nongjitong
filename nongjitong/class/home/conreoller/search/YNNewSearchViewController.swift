//
//  YNNewSearchViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/29.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class YNNewSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, YNSearchViewControllerDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var resaultController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SB_Search_Resault") as! YNSearchViewController
    
    var searchBar: UISearchBar!
    
    var resaultArray = [YNSearchCatagoryModel]() {
    
        didSet {
        
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        
        if kIOS7() {
        
            self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
            self.searchBar.placeholder = "请输入关键词"
            self.searchBar.delegate = self
            self.tableView.tableHeaderView = self.searchBar
            
        } else {
            
            self.resaultController.delegate = self
            
            self.searchController = UISearchController(searchResultsController: self.resaultController)
            
            self.searchController.searchResultsUpdater = self
            self.searchController.delegate = self
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.searchBar.sizeToFit()
            self.searchController.searchBar.placeholder = "请输入关键词"
            self.searchController.searchBar.delegate = self
            self.tableView.tableHeaderView = self.searchController.searchBar
        
        }
    
        
        definesPresentationContext = true
        
        
        //MARK: 加载文章分类数据
        getCategoryFromServer()
    }
    
    func getCategoryFromServer() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Search",
            "a": "getCategory"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let resaultData = json["data"] as! NSArray
                    if resaultData.count > 0 {
                        
                        var tempArray = [YNSearchCatagoryModel]()
                        
                        for item in resaultData {
                            
                            let dict = item as! NSDictionary
                            
                            let resaultModel = YNSearchCatagoryModel(dict: dict)
                            
                            tempArray.append(resaultModel)
                        }
                        
                        self.resaultArray = tempArray
                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("对不起，没有相关文章分类", toView: self.view)
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
    

    //MARK: tableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.resaultArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifer = "CELL_ArticleType"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifer)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Value1, reuseIdentifier: identifer)
        }
        
        let model = self.resaultArray[indexPath.row]
        
        cell?.textLabel?.text = model.name
        cell?.detailTextLabel?.text = "\(model.docs!)篇相关文章"
        cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        
        return cell!
        
    }
    
    //MARK: tableView delegate 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SB_Search_Resault") as! YNSearchViewController
        
        vc.isSearchResault = false
        vc.model = self.resaultArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        

        
    }
    
    
    //MARK:UISearchControllerDelegate
    func willPresentSearchController(searchController: UISearchController) {
        
        self.tabBarController?.tabBar.hidden = true
    
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        
        self.tabBarController?.tabBar.hidden = false

    }
 
    //MARK: scrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.view.endEditing(true)
    }
    
    //MARK: YNSearchResaultViewControllerDelegate
    func searchResaultViewControllerScrollViewDidScrollEndEdit() {
        
        self.view.endEditing(true)
    }
    
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        //MARK: 加载搜索结果
        self.resaultController.searchText = searchBar.text!
        
    }
    
   //MARK: YNSearchViewControllerDelegate
    func searchViewControllerDidSelectRowAtIndexPath(model: YNSearchResaultModel) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewControllerWithIdentifier("SB_Resault_Details") as! YNSearchResaultDetailViewController
        
        vc.searchresault = model
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
