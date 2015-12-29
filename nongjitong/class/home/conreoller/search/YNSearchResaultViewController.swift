//
//  YNSearchResaultViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/29.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit



protocol YNSearchResaultViewControllerDelegate {

    func searchResaultViewControllerScrollViewDidScrollEndEdit()
}

class YNSearchResaultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: YNSearchResaultViewControllerDelegate?
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height))
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
    }
    
    //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifer = "CELL_ArticleType"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifer)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Value1, reuseIdentifier: identifer)
        }
        
        cell?.textLabel?.text = "rose"
        cell?.contentView.backgroundColor = UIColor.redColor()
        
        return cell!
        
    }
    
    //MARK: scrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.delegate?.searchResaultViewControllerScrollViewDidScrollEndEdit()
    }
    
}
