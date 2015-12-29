//
//  YNNewSearchViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/29.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class YNNewSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, YNSearchResaultViewControllerDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    var resultSearchController: UISearchController!
    
    var searchBar: UISearchBar!
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if kIOS7() {
        
            self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
            self.searchBar.placeholder = "请输入关键词"
            self.searchBar.delegate = self
            self.tableView.tableHeaderView = self.searchBar
            
        } else {
        
            let vc = YNSearchResaultViewController()
            vc.delegate = self
            
            self.resultSearchController = UISearchController(searchResultsController: vc)
            
            self.resultSearchController.searchResultsUpdater = self
            self.resultSearchController.delegate = self
            self.resultSearchController.dimsBackgroundDuringPresentation = false
            self.resultSearchController.searchBar.sizeToFit()
            self.resultSearchController.searchBar.placeholder = "请输入关键词"
            self.resultSearchController.searchBar.delegate = self
            self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        }
        
        
        
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
    
}
