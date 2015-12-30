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
        
    }
    
    func getCategoryFromServer() {
    
        
    }
    
    
    
    //MARK: tableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifer = "CELL_ArticleType"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifer)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Value1, reuseIdentifier: identifer)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
        
    }
    
    //MARK: tableView delegate 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.tableView {
        
        
            
            
        } else {
        
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyBoard.instantiateViewControllerWithIdentifier("SB_Resault_Details") as! YNSearchResaultDetailViewController
            
//            vc.searchresault = model
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        
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
