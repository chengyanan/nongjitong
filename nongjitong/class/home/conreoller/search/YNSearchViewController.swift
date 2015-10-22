//
//  YNSearchViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/20.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    
    //MARK: - private proporty
    @IBOutlet weak var tableView: UITableView!
    
    var page: Int = 1
    var pagecount: Int = 20
    
    var tempResaultArray = [YNSearchResaultModel]()
    var resaultArray: Array<YNSearchResaultModel>? {
    
        didSet {
        
            self.tableView.reloadData()
        }
    
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.navigationItem.titleView = self.searchBar
        
        self.tableView.hidden = true
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        self.page = 1
        self.tempResaultArray = [YNSearchResaultModel]()
        
        //MARK: 加载搜索结果
        search()
    }
    
    func search() {
        
            let params = ["m": "Appapi",
                "key": "edge5de7se4b5xd",
                "c": "Search",
                "a": "search",
                "keyword": self.searchBar.text,
                "page": String(page),
                "pagecount": "\(pagecount)"
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
                        
                            self.tableView.hidden = false
                            for item in resaultData {
                            
                                let dict = item as! NSDictionary
                                
                                let resaultModel = YNSearchResaultModel(dict: dict)
                                
                                self.tempResaultArray.append(resaultModel)
                            }
                        
                            self.resaultArray = self.tempResaultArray
                            
                        } else {
                        
                            //TODO:没数据
                            YNProgressHUD().showText("对不起，没有相关文章", toView: self.view)
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
        
            return tempArray.count + 1
        }
        
        return 0
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
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == self.resaultArray?.count {
        
            loadMore()
        
        } else {
        
            self.searchBar.endEditing(true)
            self.performSegueWithIdentifier("Segue_SearchResault_Detail", sender: indexPath.row)
            
        }
        
    }
    
    func loadMore() {
    
        self.page++
        self.search()
    }
    
    //MARK: - prepare segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "Segue_SearchResault_Detail" {
        
            //传递数据
            let vc = segue.destinationViewController as? YNSearchResaultDetailViewController
            
            let row = sender as! Int
            vc?.searchresault = self.resaultArray![row]
            
        }
        
    }
    
    
    //MARK: event response
    @IBAction func cancleBarOtemClick(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
   
    let searchBar: UISearchBar = {
        
        let tempSearchBar = UISearchBar()
        tempSearchBar.placeholder = "请输入关键词"
        return tempSearchBar
        
        }()
    
}
