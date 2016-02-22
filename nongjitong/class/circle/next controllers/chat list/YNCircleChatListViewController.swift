//
//  YNCircleChatListViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/30.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNCircleChatListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {

    var model: YNCircleModel? {
        
        didSet {
            
            self.title = model?.title!
        }
    }
    let leftRightMargin: CGFloat = 10
    let itemSpacing: CGFloat = 3
    let tableViewHeight: CGFloat = 44
    let collectionEdgeInsetTopBottom: CGFloat = 12
    
    var addButton: UIButton?
    var tableView: UITableView?
    var collectionView: UICollectionView?
    //collectionViewdatasource
    var selectedArray: [YNSelectedProductModel] = {
        
        let model1 = YNSelectedProductModel(id: "1", name: "通知")
        model1.isSelected = true
        let model2 = YNSelectedProductModel(id: "2", name: "销售")
        let model3 = YNSelectedProductModel(id: "3", name: "采购")
        let model4 = YNSelectedProductModel(id: "4", name: "分成")
        let model5 = YNSelectedProductModel(id: "5", name: "台帐")
        let model6 = YNSelectedProductModel(id: "6", name: "意见")
        
        let model7 = YNSelectedProductModel(id: "7", name: "投票")
        let model8 = YNSelectedProductModel(id: "8", name: "统计")
        
        return [model1, model2, model3, model4, model5, model6, model7, model8]
    }()
    
    //tableviewDatasource
    var tableViewDataArray = [YNThreadModel]()
    
    var currentClassIdIndex: String? = "1"
    
    //加载当前的页数
    var pageCount = 1
    
    //是否显示加载更多
    var isShowLoadMore = false {
        
        didSet {
            
            if isShowLoadMore {
                
                self.tableView?.addFooterRefresh()
            } else {
                
                self.tableView?.removeFooterRefresh()
            }
        }
    }
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_InfoMulti"), style: .Plain, target: self, action: "rightItemClick")
        
        setInterface()
        setLayout()
        
        loaddata()
        
        self.tableView?.addHeaderRefreshWithActionHandler({ () -> Void in
            
            self.loadDataHeaderRefresh()
            
        })
        
        self.tableView?.addFooterRefreshWithActionHandler({ () -> Void in
            
            self.loadMore()
        })
    }
    func loadDataHeaderRefresh() {
        
        self.pageCount = 1
        //加载问题数据
        loaddata()
    }
 
    
    //MARK: event response
    func rightItemClick() {
    
        //进入详细页面
        let vc = YNCircleDetailsViewController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func addButtonClick() {
        
        //判断是哪一个前六个一样 第七第八不一样
        switch self.currentClassIdIndex! {
            
        case "1", "2", "3", "4", "5", "6":
            
            //进入创建界面
            let vc = YNCreatViewController(calssId: self.currentClassIdIndex!, group_id: model!.id!)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case "7":
            
            //创建投票
            let vc = YNCreatVoteViewController(group_id: model!.id!)
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case "8":
            //创建统计
            break
            
        default:
            
            break
            
        }
        
        
        
    }
    
    func setLayout() {
    
        //collectionView
        Layout().addTopConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addLeftConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView!, toView: self.view, multiplier: 1, constant: -44)
        Layout().addHeightConstraint(collectionView!, toView: nil, multiplier: 0, constant: 44)
        
        //addButton
        Layout().addTopBottomConstraints(addButton!, toView: collectionView!, multiplier: 1, constant: 0)
        Layout().addRightConstraint(addButton!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(addButton!, toView: collectionView!, multiplier: 1, constant: 0)
        
        //tableView
        Layout().addTopToBottomConstraint(tableView!, toView: collectionView!, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    func setInterface() {
    
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        //collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flow.scrollDirection = .Horizontal
        
        let tempCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tempCollectionView.backgroundColor = kRGBA(244, g: 244, b: 244, a: 1)
        tempCollectionView.registerClass(YNQuestionCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Collection_Question_List")
        tempCollectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tempCollectionView)
        self.collectionView = tempCollectionView
        
        self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
        
        
        //addButton
        let tempButton = UIButton()
        tempButton.setImage(UIImage(named: "addNewSubscription"), forState: UIControlState.Normal)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        tempButton.backgroundColor = kRGBA(244, g: 244, b: 244, a: 1)
        self.view.addSubview(tempButton)
        self.addButton = tempButton
        
    }
    
   
    
    //MARK:UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedArray.count > 0 {
            
            return selectedArray.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify = "Cell_Collection_Question_List"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNQuestionCollectionViewCell
        
        cell.productModel = selectedArray[indexPath.item]
        
        return cell
        
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let model = selectedArray[indexPath.item]
        let width = widthForView(model.class_name, font: UIFont.systemFontOfSize(17))
        
        return CGSize(width: width + 12, height: tableViewHeight - 1)
        
    }
    
    func widthForView(text:String, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, CGFloat.max))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    //MARK: collectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        
        if !model.isSelected {
            
            model.isSelected = true
            
            self.currentClassIdIndex = model.class_id
            
            self.pageCount = 1
            
            //判断是哪一个前六个一样 第七第八不一样
            switch self.currentClassIdIndex! {
            
                case "1", "2", "3", "4", "5", "6":
                    //加载新数据
                    loaddata()
                    break
                
                case "7":
                
                    //加载投票数据
                    loadVoteList()
                    
                    break
                
                case "8":
                    //TODO:加载统计数据
                    
                    
                    break
                
            default:
                
                    break
                
            }
            
            
            
            collectionView.reloadItemsAtIndexPaths([indexPath])
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        model.isSelected = false
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //TODO:添加Switch
        
        return self.tableViewDataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let identify = "CELL_Question"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNThreadListTableViewCell
        
        if cell == nil {
            
            cell = YNThreadListTableViewCell(style: .Default, reuseIdentifier: identify)
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
      
        
        //判断是哪一个前六个一样 第七第八不一样
        switch self.currentClassIdIndex! {
            
        case "1", "2", "3", "4", "5", "6":
            
            //点击进入加载数据, 前6个
            let detailVc = YNThreadDetailsViewController(type: self.currentClassIdIndex!, model: self.tableViewDataArray[indexPath.section])
            self.navigationController?.pushViewController(detailVc, animated: true)
            
            break
            
        case "7":
            
            //进入投票详情页
            let detailVc = YNVotoDetailsViewController(type: self.currentClassIdIndex!, model: self.tableViewDataArray[indexPath.section])
            self.navigationController?.pushViewController(detailVc, animated: true)
            
            break
            
        case "8":
            //TODO:加载统计数据
            
            
            break
            
        default:
            
            break
            
        }
        
       
 
        
    }
    
    func loadMore() {
        
        self.pageCount++
        
        //加载数据
        loaddata()
    }
    
    
    //MARK: 加载1到6数据列表
    func loaddata() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Thread",
            "a": "getList",
            "group_id": model?.id,
            "type": self.currentClassIdIndex,
            "page": "\(pageCount)"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            self.tableView?.stopRefresh()
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let temparray = json["data"] as? NSArray
                        
                        if temparray?.count < 20 {
                        
                            //显示加载更多
                            self.isShowLoadMore = false
                            
                        } else {
                        
                            //不显示加载更多
                            self.isShowLoadMore = true
                        }
                        
                        if self.pageCount == 1 {
                        
                            self.tableViewDataArray.removeAll()
                        }
                        
                        for item in temparray! {
                        
                            let tempModel = YNThreadModel(dict: item as! NSDictionary)
                            
                            self.tableViewDataArray.append(tempModel)
                            
                        }
                    
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
                
                self.tableView?.stopRefresh()
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    //MARK: 加载投票列表
    func loadVoteList() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "GroupVote",
            "a": "getList",
            "group_id": model?.id,
            "user_id": kUser_ID() as? String,
            "page": "\(pageCount)"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            self.tableView?.stopRefresh()
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let temparray = json["data"] as? NSArray
                        
                        if temparray?.count < 20 {
                            
                            //显示加载更多
                            self.isShowLoadMore = false
                            
                        } else {
                            
                            //不显示加载更多
                            self.isShowLoadMore = true
                        }
                        
                        if self.pageCount == 1 {
                            
                            self.tableViewDataArray.removeAll()
                        }
                        
                        for item in temparray! {
                            
                            let tempModel = YNThreadModel(dict: item as! NSDictionary)
                            
                            self.tableViewDataArray.append(tempModel)
                            
                        }
                        
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
                
                self.tableView?.stopRefresh()
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    
}
