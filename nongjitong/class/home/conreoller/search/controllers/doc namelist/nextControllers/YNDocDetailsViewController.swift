//
//  YNDocDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YNDocDetailListHeaderViewDelegate {

    var searchresault: YNSearchResaultModel? {
        
        didSet {
            
            self.title = searchresault?.title
            loadDetail()
        }
        
    }
    
    var serachResaultDetail: YNSearchResaultDetailModel? {
        
        didSet {
            
            //刷新tableView
            self.setTableView()
            
            //加载解决方案
            self.loadSolution()
        }
    }
    
    let tableView: UITableView = {
    
        let tempView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        
        return tempView
        
    }()
    
    let headerView: YNDocDetailListHeaderView = {
    
        let tempView = YNDocDetailListHeaderView()
        tempView.frame = CGRectMake(0, 0, kScreenWidth, 44)
        return tempView
    
    }()
    
    
    var segmentCurrentIndex = 0
    var isShowMore = false
    var solutionarray = [YNSearchSolutionListModel]() {
    
        didSet {
        
            //刷新section 2 he 3
            
            self.tableView.reloadData()
            
//            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.None)
//            self.tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    var questionArray = [YNQuestionModel]() {
    
        didSet {
            
            self.tableView.reloadData()
        
            //刷新section 2 he 3
//            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.None)
//            self.tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        headerView.delegate = self
    }
    
    func setTableView() {
    
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
//        tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    
        self.view.addSubview(tableView)
        
        Layout().addTopConstraint(tableView, toView: self.view, multiplier: 1, constant: 64)
        Layout().addLeftConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    //MARK: private method
    func loadDetail() {
        
        let params = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Search",
            "a": "doc",
            "id": self.searchresault?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
//            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let dict = json["data"] as! NSDictionary
                    
                    let resaultDetail = YNSearchResaultDetailModel(dict: dict)
                    
                    self.serachResaultDetail = resaultDetail
                    
                    
                    
                } else if status == 0 {
                    
                    if let _ = json["msg"] as? String {
                        
                        YNProgressHUD().showText("没有文章详情", toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
    }
   
    //MARK:UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if segmentCurrentIndex == 0 {
        
            return 4
        }
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
        
            if segmentCurrentIndex == 0 {
            
                if isShowMore {
                
                    return self.solutionarray.count + 1
                    
                } else {
                
                     return self.solutionarray.count
                }
                
                
            } else if segmentCurrentIndex == 1 {
                
                if isShowMore {
                
                    return self.questionArray.count + 1
                    
                } else {
                
                    return self.questionArray.count
                    
                }
                
                
            }
            
            
        } else if section == 3 {
        
            if segmentCurrentIndex == 0 {
            
                return 1
            } else {
            
                return 0
            }
        }
        return 1
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return self.view.frame.size.height * 0.3
        
        } else if indexPath.section == 1 {
            
            return self.view.frame.size.height * 0.4
            
        } else if indexPath.section == 2 {
        
            if segmentCurrentIndex == 0 {
            
                if indexPath.row == self.solutionarray.count {
                
                    return 44
                }
                
                return self.solutionarray[indexPath.row].height!
                
            } else if segmentCurrentIndex == 1 {
                
                if indexPath.row == self.solutionarray.count {
                    
                    return 44
                }
                
                return self.questionArray[indexPath.row].height!
                
            }
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            
            let identifier = "CELL_DocList_album"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNDocAlbumTableViewCell
            
            if cell == nil {
                
                cell = YNDocAlbumTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            cell?.photos = self.serachResaultDetail!.photos
            
            cell?.selectionStyle = .None
            
            return cell!
            
            
        } else if indexPath.section == 1 {
        
            let identifier = "CELL_DocList_detail"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? YNWebContentTableViewCell
            
            if cell == nil {
                
                cell = YNWebContentTableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            cell?.serachResaultDetail = self.serachResaultDetail
            
            cell?.selectionStyle = .None
            
            return cell!
            
        } else if indexPath.section == 2 {
        
            if segmentCurrentIndex == 0 {
            
                if indexPath.row == self.solutionarray.count {
             
                    let identify = "CELL_Write_something"
                    var cell = tableView.dequeueReusableCellWithIdentifier(identify)
                    
                    if cell == nil {
                        
                        cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
                    }
                    
                    cell?.textLabel?.textAlignment = .Center
                    
                    cell?.textLabel?.text = "查看更多数据"
                    cell?.selectionStyle = .None
                    
                    return cell!
                    
                }
                
                let model = self.solutionarray[indexPath.row]
                
                if model.photos?.count > 0 {
                    
                    
                    let identify: String = "Cell_Search_Resault_listWithImage"
                    var cell: YNSearchSolutionWithImageCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionWithImageCell
                    
                    if cell == nil {
                        
                        cell = YNSearchSolutionWithImageCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                        
                    }
                    
                    cell?.selectionStyle = .None
                    cell?.solutionModel = self.solutionarray[indexPath.row]
                    
                    return cell!
                    
                }
                
                let identify: String = "Cell_Search_Resault_list"
                var cell: YNSearchSolutionCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? YNSearchSolutionCell
                
                if cell == nil {
                    
                    cell = YNSearchSolutionCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                    
                }
                
                cell?.solutionModel = self.solutionarray[indexPath.row]
                cell?.selectionStyle = .None
                return cell!

                
                
            } else if segmentCurrentIndex == 1 {
            
            
                if indexPath.row == self.questionArray.count {
                    
                    let identify = "CELL_Write_something"
                    var cell = tableView.dequeueReusableCellWithIdentifier(identify)
                    
                    if cell == nil {
                        
                        cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
                    }
                    
                    cell?.textLabel?.textAlignment = .Center
                    
                    cell?.textLabel?.text = "查看更多数据"
                    cell?.selectionStyle = .None
                    return cell!
                    
                }
                
                
                let identify = "CELL_Question"
                
                var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNQuestionTableViewCell
                
                if cell == nil {
                    
                    cell = YNQuestionTableViewCell(style: .Default, reuseIdentifier: identify)
                }
                
                cell?.model = self.questionArray[indexPath.section]
                cell?.selectionStyle = .None
                return cell!
                
             
            }
            
            
        } else if indexPath.section == 3 {
        
            
            let identify = "CELL_Write_something"
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            cell?.textLabel?.textAlignment = .Center
            
            cell?.textLabel?.text = "写方案"
            cell?.selectionStyle = .None
            
            return cell!
            
        }
        

        let identify = "text"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.text = "rose"
        cell?.selectionStyle = .None
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            
            return 44
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 11
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            
            return headerView
        }
        
        return nil
    }
    
    //MARK: tableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
        
            if segmentCurrentIndex == 0 {
            
                if indexPath.row == self.solutionarray.count {
                
                    //进方案列表页面
                    let vc = YNSearchResaultSolutionViewController()
                    vc.solutionType = SolutionType.Article
                    vc.searchresault = self.searchresault
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            } else if segmentCurrentIndex == 1 {
            
                if indexPath.row == self.solutionarray.count {
                
                    //进入相关问题页面
                    let vc = YNSearchResaultQuestionViewController()
                    vc.docId = self.searchresault?.id
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                
                }
                
      
            }
            
        } else if indexPath.section == 3 {
        
            //进入写方案页面
            let vc = YNWriteSolutionViewController()
            vc.actionType = ActionType.WriteProgram
            vc.searchresault = self.searchresault
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK: YNDocDetailListHeaderViewDelegate
    func segmentValueChange(value: Int) {
        
        self.segmentCurrentIndex = value
        
        if value == 0 {
        
            //加载解决方案
            loadSolution()
            
        } else if value == 1 {
        
            //加载相关问题
            loadQuestionList()
        
        }
        
    }
    
    
    //MARK: 加载相关解决方案
    func loadSolution() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "DocPrograms",
            "a": "getDocProgramsList",
            "doc_id": searchresault?.id,
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
                        
                        if resaultData.count < 20 {
                            
                            //显示加载更多
                            self.isShowMore = false
                        } else {
                            
                            //不显示加载更多
                            self.isShowMore = true
                        }

                        
                        var tempArray = [YNSearchSolutionListModel]()
                        
                        for item in resaultData {
                            
                            let dict = item as! NSDictionary
                            
                            let resaultModel = YNSearchSolutionListModel(dict: dict)
                            
                            tempArray.append(resaultModel)
                        }
                        
                        self.solutionarray = tempArray
                        
                    } else {
                        
                        //没数据
                        
                        self.tableView.reloadData()
                        
//                        if self.segmentCurrentIndex == 0 {
//                        
//                            YNProgressHUD().showText("没有相关解决方案", toView: self.view)
//                            
//                        } else if self.segmentCurrentIndex == 0 {
//                        
//                            YNProgressHUD().showText("没有相关问题", toView: self.view)
//                            
//                        }
                        
                        
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
    
    
    //MARK: 加载问题数据
    func loadQuestionList() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "getQuestionList",
            "class_id": self.searchresault?.id,
           
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpQuestion().getQuestionListWithClassID(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            if let status = json["status"] as? Int {
                
                //                print(json)
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        
                        if tempdata.count < 20 {
                            
                            //显示加载更多
                            self.isShowMore = false
                        } else {
                            
                            //不显示加载更多
                            self.isShowMore = true
                        }
                        
                        var tempArray = [YNQuestionModel]()
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNQuestionModel(dict: tempdata[i] as! NSDictionary)
                            
                            tempArray.append(model)
                        }
                        
                        self.questionArray = tempArray
                        
                        
                    } else {
                        
                        //没有数据
                        
                        YNProgressHUD().showText("没有相关问题", toView: self.view)
                        self.isShowMore = false
                        self.questionArray = [YNQuestionModel]()
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
    
    
    
}
