//
//  YNSecondSearchViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/15.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class YNSecondSearchViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, YNSearchViewControllerDelegate, UISearchResultsUpdating {

    var searchController: UISearchController!
    
    var resaultController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SB_Search_Resault") as! YNSearchViewController
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if kIOS7() {
            
            self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
            self.searchBar.placeholder = "请输入关键词"
            self.searchBar.delegate = self

            
        } else {
            
            self.resaultController.delegate = self
            
            self.searchController = UISearchController(searchResultsController: self.resaultController)
            self.searchController.delegate = self
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.searchBar.sizeToFit()
            self.searchController.searchBar.placeholder = "请输入关键词"
            self.searchController.searchBar.delegate = self

            
            self.searchController.searchBar.backgroundColor = UIColor.redColor()
            
            self.view.addSubview(self.searchController.searchBar)
            self.searchController.searchBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 44)
            
        }
    

        definesPresentationContext = true
        
//        self.navigationController?.automaticallyAdjustsScrollViewInsets = true
    }
    
    
    //MARK:UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        
        
    }
    
    //MARK:UISearchControllerDelegate
    func willPresentSearchController(searchController: UISearchController) {
        
        self.navigationController?.navigationBar.translucent = true
        
        self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        self.tabBarController?.tabBar.hidden = true
        
//        print(self.searchController.searchBar.frame, self.searchController.searchBar.hidden)
        
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        
        self.navigationController?.navigationBar.translucent = false
        
        self.searchController.searchBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 44)
        self.tabBarController?.tabBar.hidden = false
        
//        print(self.searchController.searchBar.frame)
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = false
    }
    
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
