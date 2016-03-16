//
//  YNTrainViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/11.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNTrainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

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
    
    let leftRightMargin: CGFloat = 10
    let itemSpacing: CGFloat = 3
    let tableViewHeight: CGFloat = 44
    let collectionEdgeInsetTopBottom: CGFloat = 12
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    var addButton: UIButton?
    
    //collectionViewdatasource
    var selectedArray = [YNSelectedProductModel]()
    
    //tableviewDatasource
    var tableViewDataArray = [YNQuestionModel]()
    
    // 当前问题的classId
    var classId: String? = nil
    //
    var currentClassIdIndex: Int = 0
    
    //加载当前的页数
    var pageCount = 1
    
    var isFirst = true
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "培训"
        
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
        
        
        
        print("rose")
        
        
        
    }
    
    func loadDataHeaderRefresh() {
        
        self.pageCount = 1
        //加载问题数据
        getQuestionListWithClassID(self.classId)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView?.addRefresh()
        
        //        self.loadDataFromServer()
        
        self.loadWatchList()
        
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
    
    func addButtonClick() {
        
        if let _ = kUser_ID() {
            
            //已登陆我的关注
            let vc = YNMyWatchListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            //没有登录，直接跳到登录界面
            let signInVc = YNSignInViewController()
            
            let navVc = UINavigationController(rootViewController: signInVc)
            
            self.presentViewController(navVc, animated: true, completion: { () -> Void in
                
            })
            
            
        }
        
        
    }
    
    @IBAction func askQuestionClick(sender: AnyObject) {
        
        if let _ = kUser_ID() as? String {
            
            //已登陆
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let askVc = mainStoryBoard.instantiateViewControllerWithIdentifier("SB_AskQuestion")
            
            
            self.presentViewController(askVc, animated: true) { () -> Void in
                
            }
            
            
        } else {
            
            //未登录
            let signInVc = YNSignInViewController()
            let signInNaVc = UINavigationController(rootViewController: signInVc)
            self.presentViewController(signInNaVc, animated: true, completion: { () -> Void in
                
            })
            
        }
        
        
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
            "page": "\(pageCount)",
            "descript_length": nil
        ]
        
        var progress : ProgressHUD?
        
        if isFirst {
            
            progress = YNProgressHUD().showWaitingToView(self.view)
            
        }
        
        YNHttpQuestion().getQuestionListWithClassID(params, successFull: { (json) -> Void in
            
            
            self.tableView?.stopRefresh()
            
            if self.isFirst {
                
                progress!.hideUsingAnimation()
                
                self.isFirst = false
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
                        
                        if self.pageCount == 1 {
                            
                            //刷新
                            YNProgressHUD().showText("没有数据", toView: self.view)
                            
                            self.tableViewDataArray.removeAll()
                            
                        } else {
                            
                            //加载更多
                            
                            //没有数据
                            YNProgressHUD().showText("没有更多数据了", toView: self.view)
                            
                            self.isShowLoadMore = false
                            
                        }
                        
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
                
                if self.isFirst {
                    
                    progress!.hideUsingAnimation()
                    
                    self.isFirst = false
                }
                
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
        
    }
    
    //MARK: 加载关注数据
    func loadWatchList() {
        
        //        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        //判断 登录 没登录
        let userId = kUser_ID()
        
        if let _ = userId {
            
            YNWatchHttp.getUserSpecialty({ (json) -> Void in
                //            progress.hideUsingAnimation()
                
                //            print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let tempdata = json["data"] as! NSArray
                        
                        self.selectedArray.removeAll()
                        
                        let newmodel = YNSelectedProductModel()
                        newmodel.class_name = "最新"
                        newmodel.class_id = nil
                        //                    newmodel.isSelected = true
                        self.selectedArray.append(newmodel)
                        
                        var isExist = false
                        
                        if tempdata.count > 0 {
                            
                            for var i = 0; i < tempdata.count; i++ {
                                
                                let model = YNSelectedProductModel(dict: tempdata[i] as! NSDictionary)
                                
                                if self.classId == model.class_id {
                                    
                                    model.isSelected = true
                                    isExist = true
                                    
                                    self.currentClassIdIndex = i + 1
                                }
                                
                                self.selectedArray.append(model)
                                
                            }
                            
                            if isExist {
                                
                                self.collectionView?.reloadData()
                                self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: self.currentClassIdIndex, inSection: 0), animated: false, scrollPosition: .None)
                                
                            } else {
                                
                                newmodel.isSelected = true
                                self.collectionView?.reloadData()
                                self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                            }
                            
                            
                        }  else {
                            
                            //没有数据
                            newmodel.isSelected = true
                            
                            self.collectionView?.reloadData()
                            self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                        }
                        
                        
                        
                    } else if status == 0 {
                        
                        
                        if let msg = json["msg"] as? String {
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                            print("关注数据获取失败: \(msg)")
                        }
                    }
                    
                }
                
                
                }) { (error) -> Void in
                    
                    //                progress.hideUsingAnimation()
                    
                    
                    self.noWatchLiset()
                    
                    YNProgressHUD().showText("数据加载失败", toView: self.view)
            }
            
        } else {
            
            //没登录
            noWatchLiset()
        }
        
        
        
        
    }
    
    func noWatchLiset() {
        
        self.selectedArray.removeAll()
        
        let newmodel = YNSelectedProductModel()
        newmodel.class_name = "最新"
        newmodel.class_id = nil
        self.selectedArray.append(newmodel)
        newmodel.isSelected = true
        
        self.collectionView?.reloadData()
        self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
    }
    
    //MARK: 设置界面
    func setupInterface() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.hidden = true
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
        
        //addButton
        let tempButton = UIButton()
        tempButton.setImage(UIImage(named: "addNewSubscription"), forState: UIControlState.Normal)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tempButton)
        self.addButton = tempButton
        
        
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
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -49)
        
        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
//        return self.tableViewDataArray.count
        
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_Temp"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
    
        cell?.textLabel?.text = "rose"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        if indexPath.section == self.tableViewDataArray.count {
//            
//            return 44
//        }
//        return self.tableViewDataArray[indexPath.section].height!
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func loadMore() {
        
        self.pageCount++
        
        //加载问题数据
        getQuestionListWithClassID(self.classId)
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
            
            self.classId = model.class_id
            
            self.pageCount = 1
            
            //加载新数据
            getQuestionListWithClassID(model.class_id)
            
            collectionView.reloadItemsAtIndexPaths([indexPath])
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
            
        }
        
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
