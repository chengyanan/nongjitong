//
//  YNOfflineQuestionListViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/28.
//  Copyright © 2015年 农盟. All rights reserved.
// 线下救援问题列表

import UIKit

class YNOfflineQuestionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var isOutLine = "Y"
    
    //是否显示加载更多
    var isShowLoadMore = true {
        
        didSet {
            
            if isShowLoadMore {
                
                self.tableView?.addFooterRefresh()
            } else {
                
                self.tableView?.removeFooterRefresh()
            }
        }
    }
    
    let leftRightMargin: CGFloat = 10
    let itemSpacing: CGFloat = 3
    let tableViewHeight: CGFloat = 44
    let collectionEdgeInsetTopBottom: CGFloat = 12
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    //collectionViewdatasource
    var selectedArray = [YNSelectedProductModel]()
    
    //tableviewDatasource
    var tableViewDataArray = [YNQuestionModel]()
    
    // 当前问题的classId
    var classId: String? = nil
    
    //加载当前的页数
    var pageCount = 1
    
    var isFirstLoadData = true
    
    
    //MARK: life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "线下救援问题"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = kRGBA(244, g: 244, b: 244, a: 1)
        
        setupInterface()
        setLayout()
        
        loadDataFromServer()
        
        
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
        getQuestionListWithClassID(self.classId)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView?.addRefresh()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView?.removeRefresh()
    }
    
    //MARK: event response
    @IBAction func leftbarButtonClick(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
        
    }
    
    
    //MARK: 数据加载
    func loadDataFromServer() {
        
        if let _ = kUser_ID() as? String {
            
            //已登陆，加载关注数据
            loadWatchList()
            
        } else {
            
            //未登录
            self.selectedArray.removeAll()
            let newmodel = YNSelectedProductModel()
            newmodel.class_name = "最新"
            newmodel.isSelected = true
            self.selectedArray.append(newmodel)
            
            self.collectionView?.reloadData()
            self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
        }
        
        
        //加载问题数据
        getQuestionListWithClassID(self.classId)
        
    }
    
    //MARK: 加载问题数据
    func getQuestionListWithClassID(classId: String?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "getQuestionList",
            "class_id": classId,
            "page": "\(self.pageCount)",
            "descript_length": nil,
            "is_outline": isOutLine
        ]
        
        var progress : ProgressHUD?
        
        if isFirstLoadData {
            
            progress = YNProgressHUD().showWaitingToView(self.view)
            
        }
        
        YNHttpQuestion().getQuestionListWithClassID(params, successFull: { (json) -> Void in
            
            self.tableView?.stopRefresh()
            
            if self.isFirstLoadData {
                
                progress!.hideUsingAnimation()
                
                self.isFirstLoadData = false
            }
            
            if let status = json["status"] as? Int {
                
                //                print(json)
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        if tempdata.count < 20 {
                            
                            //显示加载更多
                            self.isShowLoadMore = false
                        } else {
                            
                            //不显示加载更多
                            self.isShowLoadMore = true
                        }
                        
                        if self.pageCount == 1 {
                            
                            self.tableViewDataArray.removeAll()
                        }
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNQuestionModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.tableViewDataArray.append(model)
                        }
                        
                        self.tableView?.reloadData()
                        self.tableView?.hidden = false
                        
                    } else {
                        
                        //没有数据
                        
                        YNProgressHUD().showText("没有数据了", toView: self.view)
                        
                        self.isShowLoadMore = false
                        
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
                
                self.tableView?.stopRefresh()
                
                if self.isFirstLoadData {
                    
                    progress!.hideUsingAnimation()
                    
                    self.isFirstLoadData = false
                }
                
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
        
        
    }
    
    func loadMore() {
        
        self.pageCount++
        
        //加载问题数据
        getQuestionListWithClassID(self.classId)
    }
    
    //MARK: 加载关注数据
    func loadWatchList() {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNWatchHttp.getUserSpecialty({ (json) -> Void in
            progress.hideUsingAnimation()
            
            //            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    self.selectedArray.removeAll()
                    
                    let newmodel = YNSelectedProductModel()
                    newmodel.class_name = "最新"
                    newmodel.isSelected = true
                    self.selectedArray.append(newmodel)
                    
                    if tempdata.count > 0 {
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNSelectedProductModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.selectedArray.append(model)
                        }
                        
                        self.collectionView?.reloadData()
                        self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                        
                    }  else {
                        
                        //                        YNProgressHUD().showText("没有数据", toView: self.view)
                    }
                    
                    
                    
                } else if status == 0 {
                    
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        print("关注数据获取失败: \(msg)")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                let newmodel = YNSelectedProductModel()
                newmodel.class_name = "最新"
                newmodel.class_id = nil
                self.selectedArray.append(newmodel)
                newmodel.isSelected = true
                
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
        tempTableView.hidden = true
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        //collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
    }
    
    func setLayout() {
        
        //collectionView
        Layout().addTopConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addLeftConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(collectionView!, toView: nil, multiplier: 0, constant: 44)
        
        //tableView
        Layout().addTopToBottomConstraint(tableView!, toView: collectionView!, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.isShowLoadMore {
            
            return self.tableViewDataArray.count + 1
            
        } else {
            
            return self.tableViewDataArray.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == self.tableViewDataArray.count {
            
            let identify: String = "Cell_Resault_LoadMore_code"
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identify)
            
            if cell == nil {
                
                cell = YNResaultLoadModeCell(style: .Default, reuseIdentifier: identify)
                
            }
            
            return cell!
            
        }
        
        let identify = "CELL_Question"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNQuestionTableViewCell
        
        if cell == nil {
            
            cell = YNQuestionTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.model = self.tableViewDataArray[indexPath.section]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == self.tableViewDataArray.count {
            
            return 44
        }
        return self.tableViewDataArray[indexPath.section].height!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == self.tableViewDataArray.count {
            
            self.loadMore()
            
        } else {
            
            let questionDetailVc = YNQuestionDetailViewController()
            questionDetailVc.questionModel = self.tableViewDataArray[indexPath.section]
            
            self.navigationController?.pushViewController(questionDetailVc, animated: true)
        }
        
        
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
        model.isSelected = true
        
        self.classId = model.class_id
        self.pageCount = 1
        //加载新数据
        getQuestionListWithClassID(model.class_id)
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        model.isSelected = false
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    override func didReceiveMemoryWarning() {
        
        print("YNQuestionViewController didReceiveMemoryWarning")
    }
    
}
