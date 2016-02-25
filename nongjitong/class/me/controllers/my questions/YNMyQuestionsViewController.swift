//
//  YNMyQuestionsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/17.
//  Copyright © 2015年 农盟. All rights reserved.
//我的提问 或 我的回答

import UIKit

enum MyDescrptionType {

    case MyQuestion, MyAnswer
}

class YNMyQuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataAttay = [YNQuestionModel]()
    
    var myType: MyDescrptionType? {
    
        didSet {
        
            if myType == .MyQuestion {
            
                self.title = "我的提问"
                self.loadMyQuestionDataFromServer()
                
            } else if myType == .MyAnswer {
            
                self.title = "我的回答"
                self.loadMyAnswerDataFromServer()
            }
        }
    }
    
    let tableView: UITableView = {
        
        let tempTableView = UITableView(frame: CGRectZero, style: .Plain)
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        return tempTableView
        
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        setLayout()
        
    }
    
    func setLayout() {
    
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
    }
    

    //MARK: load data
    func loadMyQuestionDataFromServer() {
    
        let userId = kUser_ID() as? String
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "getQuestionList",
            "user_id": userId,

        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpMyQuestion().getQuestionListWithUserID(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
//            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNQuestionModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.dataAttay.append(model)
                        }
                        
                        self.tableView.reloadData()
                        
                    }  else {
                        
                        YNProgressHUD().showText("没有提问过问题", toView: self.view)
                    }
                    
                    
                } else if status == 0 {
                    
                    
                    if let _ = json["msg"] as? String {
                        
                        YNProgressHUD().showText("数据获取失败", toView: self.view)
//                        print("数据获取失败: \(msg)")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("网络连接错误", toView: self.view)
        }
        
    }
    
    
    
    func loadMyAnswerDataFromServer() {
    
        let userId = kUser_ID() as? String
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpMyQuestion().getInvolvedQuestionWithUserID(userId, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["msg"] as! NSArray

                    if tempdata.count > 0 {
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNQuestionModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.dataAttay.append(model)
                        }
                        
                        self.tableView.reloadData()
                        
                    }  else {
                        
                        YNProgressHUD().showText("您还没有回答过问题", toView: self.view)
                    }
                    
                    
                } else if status == 0 {
                    
                    
                    if let _ = json["msg"] as? String {
                        
                        YNProgressHUD().showText("数据获取失败", toView: self.view)
//                        print("数据获取失败: \(msg)")
                    }
                }
                
            }
            
            
            }, failureFul: { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("网络连接错误", toView: self.view)
        })

        
    }
    
   //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataAttay.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let model = self.dataAttay[indexPath.row]
        
        if model.descript == "" {
        
            return model.myQuestionCellHeight! + 20
        }
        
        return model.myQuestionCellHeight!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "CELL_MyQuestion"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNMYQuestionTableViewCell
        
        if cell == nil {
        
            cell = YNMYQuestionTableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.model = self.dataAttay[indexPath.row]
        
        return cell!
    }
    
    //MARK:UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let questionDetailVc = YNQuestionDetailViewController()
        questionDetailVc.questionModel = self.dataAttay[indexPath.row]
        
        self.navigationController?.pushViewController(questionDetailVc, animated: true)
        
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if self .myType == .MyQuestion {
        
            if editingStyle == .Delete {
                
                deleteMyQuestion(self.dataAttay[indexPath.row], indexPath: indexPath)
                
            }
            
        } else {
        
            YNProgressHUD().showText("回答暂时还不能删哦", toView: self.view)
        }
        
        
    }
    
    
    func deleteMyQuestion(model: YNQuestionModel, indexPath: NSIndexPath) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "delQuestion",
            "id": model.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        
                        self.dataAttay.removeAtIndex(indexPath.row)
                        
                        self.tableView.reloadData()
                        
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
            } catch {
                
                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
    }
    
    
    
    
    
}
