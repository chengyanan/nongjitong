//
//  YNSearchResaultQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/4.
//  Copyright © 2016年 农盟. All rights reserved.
//相关问题

import UIKit

class YNSearchResaultQuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var docId: String?
    
    var tableView: UITableView?
    
    //tableviewDatasource
    var tableViewDataArray = [YNQuestionModel]()

    
    //加载当前的页数
    var pageCount = 1
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相关问题"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = kRGBA(244, g: 244, b: 244, a: 1)
        
        setupInterface()
        setLayout()
        
       loadDataFromServer()
    }

    
    //MARK: 数据加载
    func loadDataFromServer() {
    
        //加载问题数据
        getQuestionListWithDocId()
        
    }
    
    //MARK: 加载问题数据
    func getQuestionListWithDocId() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "getQuestionList",
            "class_id": self.docId,
            "page": "\(pageCount)",
            "descript_length": nil,
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpQuestion().getQuestionListWithClassID(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                //                print(json)
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        self.tableViewDataArray.removeAll()
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNQuestionModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.tableViewDataArray.append(model)
                        }
                        
                        self.tableView?.reloadData()
                        
                        self.pageCount += 1
                        
                    } else {
                        
                        //没有数据
                        
                        YNProgressHUD().showText("没有相关问题", toView: self.view)
                        self.tableViewDataArray.removeAll()
                        self.tableView?.reloadData()
                    }
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        print("问题列表数据获取失败: \(msg)")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
        
    }
    
   
    
    //MARK: 设置界面
    func setupInterface() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
    }
    
    func setLayout() {
        
        //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.tableViewDataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_Question"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNQuestionTableViewCell
        
        if cell == nil {
            
            cell = YNQuestionTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.model = self.tableViewDataArray[indexPath.section]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.tableViewDataArray[indexPath.section].height!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let questionDetailVc = YNQuestionDetailViewController()
        questionDetailVc.questionModel = self.tableViewDataArray[indexPath.section]
        
        self.navigationController?.pushViewController(questionDetailVc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        
        print("YNQuestionViewController didReceiveMemoryWarning")
    }
    
    
    
}
