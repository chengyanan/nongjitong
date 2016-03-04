//
//  YNNewsViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/3.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    var tableViewDataArray = [YNNewsModel]()
    
    // 当前问题的classId
    var classId: String? = nil
    //
    var currentClassIdIndex: Int = 0
    
    //加载当前的页数
    var pageCount = 1
    
    
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
        
        self.title = "新闻"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = kRGBA(244, g: 244, b: 244, a: 1)
        
        setupInterface()
        setLayout()
        
        loadNewsCategoryData()
        
        self.tableView?.addHeaderRefreshWithActionHandler({ () -> Void in
            
            self.loadDataHeaderRefresh()
            
        })
        
        self.tableView?.addFooterRefreshWithActionHandler({ () -> Void in
            
            self.loadMore()
        })
        
        
    }
    
    //MARK: 设置界面
    func setupInterface() {
        
        //tableView
        let tempTableView = UITableView(frame: CGRectZero, style: .Plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .None
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.rowHeight = 98
//        tempTableView.hidden = true
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
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -49)
        
        
    }

    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableViewDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_News_List"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNNewsListTableViewCell
        
        if cell == nil {
            
            cell = YNNewsListTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.model = self.tableViewDataArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailVc = YNNewsDetailsViewController(news: self.tableViewDataArray[indexPath.row])
        
        self.navigationController?.pushViewController(detailVc, animated: true)
       
    }
    
    func loadMore() {
        
        self.pageCount++
        
        //加载问题数据
        getNewsList(self.classId)

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
            getNewsList(model.class_id)
            
            collectionView.reloadItemsAtIndexPaths([indexPath])
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        model.isSelected = false
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    
   //MARK: 加载新闻分类
    func loadNewsCategoryData() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "NewsCategory",
            "a": "getChilds"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
//                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let tempArray = json["data"] as? NSArray
                        
                        if tempArray?.count > 0 {
                        
                            for var i = 0; i < tempArray!.count; i++ {
                                
                                let dict = tempArray![i]
                                
                                let model = YNSelectedProductModel(id: dict["id"] as! String, name: dict["class_name"] as! String)
                                
                                if i == 0 {
                                
                                    model.isSelected = true
                                    self.getNewsList(model.id)
                                }
                                
                                self.selectedArray.append(model)
                                
                            }
                            
                            self.collectionView!.reloadData()
                            self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                            
                            
                            
                            
                        } else {
                            
                            YNProgressHUD().showText("没有数据", toView: self.view)
                            
                        }
                        
                        
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
    
    func loadDataHeaderRefresh() {
        
        self.pageCount = 1
        //加载问题数据
        getNewsList(self.classId)

    }
    
    
    //MARK: 加载新闻列表
    func getNewsList(classId: String?) {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "News",
            "a": "getList",
            "class_id": classId,
            "page": "\(pageCount)"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        YNHttpQuestion().getQuestionListWithClassID(params, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            self.tableView?.stopRefresh()
            
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
                            
                            let model = YNNewsModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.tableViewDataArray.append(model)
                        }
                        
                        self.tableView?.reloadData()
                        
//                        self.tableView?.hidden = false
                        
                        
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
                        print("请求接口失败")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                self.tableView?.stopRefresh()
                
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
        
    }
    
    
    
    
    
    
    
}
