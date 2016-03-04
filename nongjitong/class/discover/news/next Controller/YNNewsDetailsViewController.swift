//
//  YNNewsDetailsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newsModel: YNNewsModel?
    var model: YNNewsDetailsModel?
    
    
    var tableView: UITableView?
    
    
    //MARK: life circle
    init(news: YNNewsModel) {
    
        super.init(nibName: nil, bundle: nil)
        self.newsModel = news
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "新闻详情"
        
        setupInterface()
        setLayout()
        
        //加载数据
        getNewsDetail()
    }
    
    //MARK: 设置界面
    func setupInterface() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false

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
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        
            return 3
            
        } else if section == 1 {
        
            if self.model?.comments.count > 0 {
            
                return self.model!.comments.count
                
            }
            
        } else if section == 2 {
        
            if self.model?.relation.count > 0 {
                
                return self.model!.relation.count
            }
            
        }
  
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 1 {
        
            let identify = "CELL_Tags"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNNewsTagsTableViewCell
            
            if cell == nil {
                
                cell = YNNewsTagsTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            if self.model?.newsModel?.tagsArray?.count > 0 {
                
                cell?.dataArray = self.model!.newsModel!.tagsArray!
            }
     
            return cell!
            
            
        } else if indexPath.section == 1 {
        
            let identify = "CELL_Comments"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNNewsCommentTableViewCell
            
            if cell == nil {
                
                cell = YNNewsCommentTableViewCell(style: .Default, reuseIdentifier: identify)
            }
            
            cell?.model = self.model!.comments[indexPath.row]
            
            return cell!
            
        } else if indexPath.section == 2 {
            
            
            let identify = "CELL_Relation"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
            }
        
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(13)
            cell?.textLabel?.textColor = kRGBA(0, g: 80, b: 169, a: 1)
            cell?.textLabel?.numberOfLines = 2
            cell?.textLabel?.text = self.model?.relation[indexPath.row].title
            
            return cell!
            
        }
        
        
        
        let identify = "CELL_tempCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.textAlignment = .Center
        cell?.selectionStyle = .None
        
        if indexPath.section == 0 {
        
            if indexPath.row == 0 {
            
                cell?.textLabel?.font = UIFont.systemFontOfSize(15)
                cell?.textLabel?.numberOfLines = 2
                cell?.textLabel?.textColor = kRGBA(20, g: 20, b: 20, a: 1)
                cell?.textLabel?.text = self.model?.newsModel?.title
                
            } else if indexPath.row == 2 {
                
                cell?.textLabel?.font = UIFont.systemFontOfSize(13)
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.textColor = UIColor.blackColor()
                cell?.textLabel?.text = self.model?.content
                
            } else {
            
                cell?.textLabel?.text = "rose"
            }
            

        } else {
        
            cell?.textLabel?.text = "rose"
        }
        
        
        return cell!
        
        
    }
    
    
    //MARK: tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 2 {
        
            if self.model?.contentHeight > 0 {
            
                return self.model!.contentHeight
            }
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
        
            return 30
            
            
        } else if indexPath.section == 1 {
        
            if self.model?.comments.count > 0 {
            
                return self.model!.comments[indexPath.row].height
                
            }
            
            
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
            return 0.1
        }
        
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
        
            if self.model?.comments.count > 0 {
            
                return "评论"
                
            }
            
        } else if section == 2 {
        
            if self.model?.relation.count > 0 {
            
                return "相关新闻"
            }
            
            
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section == 2 {
        
            let newsVc = YNNewsDetailsViewController(news: self.model!.relation[indexPath.row])
            
            self.navigationController?.pushViewController(newsVc, animated: true)
        }
        
    }
    
    //MARK:加载新闻详情
    func getNewsDetail() {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "News",
            "a": "getNewsDetail",
            "id": newsModel?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
//                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let tempdict = json["data"] as! NSDictionary
                        
                        self.model = YNNewsDetailsModel(dict: tempdict)
                        
                        self.tableView?.reloadData()
                        
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
    
    
    
    func setAttributeString() {
    
        
    }
    
    
    
    
}
