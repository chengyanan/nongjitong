//
//  YNMyWatchListViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/16.
//  Copyright © 2015年 农盟. All rights reserved.
//关注的领域

import UIKit

class YNMyWatchListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, YNWatchProductTableViewCellDelegate {

    enum YNReloadDataType {
        case tableViewCatagory, tableViewProduct
    }

    
    let maxNumberOfWatch = 5
    
    var collectionViewHeight: CGFloat {
    
        return self.view.frame.size.height * 0.176
    }
    
    let tableViewCatagoryWidthPercent: CGFloat = 0.33
    let numbersOfOneLine = 3
    let leftRightMargin: CGFloat = 10
    let topBottomMargin: CGFloat = 10
    let itemSpacing: CGFloat = 16
    let minimumLineSpacing: CGFloat = 13

    //tableViewCatagory数据源
    var cayegoryArray = [YNCategoryModel]()
    //tableViewProduct数据源
    var productArray = [YNCategoryModel]()
    
    //collectionViewdatasource
    var selectedArray = [YNCategoryModel]()
    
    var tableViewCatagory: UITableView?
    var tableViewProduct: UITableView?
    
    var collectionView: UICollectionView?
    let separatorImageView: UIImageView = {
    
        let tempView = UIImageView(image: UIImage(named: "watch_Separator"))
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
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
        
        self.title = "我关注的领域"
        //remove the blank of top and bottom in collectionView
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.whiteColor()
        setupInterface()
        setLayout()
        
        loadDataFromServer()
    }
    
    //MARK: 数据加载
    func loadDataFromServer() {
        
        // 加载关注数据
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNWatchHttp.getUserSpecialty({ (json) -> Void in
            progress.hideUsingAnimation()
            
            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                    
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNCategoryModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.productArray.append(model)
                        }
                        
                        
                        
                    }
                    

                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
        
        //加载选项数据
        loadHttpData("0", reloadData: .tableViewCatagory)
        
    }
    
    func setLayout() {
    
        //collectionView
        Layout().addTopConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addLeftConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(collectionView!, toView: nil, multiplier: 0, constant: collectionViewHeight)
        
        //separatorImageView
        Layout().addTopToBottomConstraint(separatorImageView, toView: collectionView!, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(separatorImageView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(separatorImageView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(separatorImageView, toView: nil, multiplier: 0, constant: 2)
        
        //tableViewCatagory
        Layout().addTopToBottomConstraint(tableViewCatagory!, toView: separatorImageView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableViewCatagory!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableViewCatagory!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(tableViewCatagory!, toView: self.view, multiplier: tableViewCatagoryWidthPercent, constant: 0)
        
        //tableViewProduct
        Layout().addTopConstraint(tableViewProduct!, toView: tableViewCatagory!, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(tableViewProduct!, toView: tableViewCatagory!, multiplier: 1, constant: 0)
        Layout().addRightConstraint(tableViewProduct!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(tableViewProduct!, toView: tableViewCatagory!, multiplier: 1, constant: 0)
        
    }
    
    //MARK: 设置界面
    func setupInterface() {
        
        self.view.addSubview(separatorImageView)
        
        setCollectionView()
        setTableViewCatagory()
        setTableViewProduct()
    }
    
    func setTableViewCatagory() {
    
        //tableViewCatagory
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tag = 1
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableViewCatagory = tempTableView

    }
    
    func setTableViewProduct() {
        
        //tableViewProduct
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tag = 2
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableViewProduct = tempTableView
        
    }
    
    func setCollectionView() {
    
        //collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.minimumLineSpacing = minimumLineSpacing
        
        let collectionWidth: CGFloat = self.view.frame.size.width
        
        let space = CGFloat(numbersOfOneLine - 1) * itemSpacing
        
        let itemWidth = (collectionWidth - leftRightMargin*2 - space) / CGFloat(numbersOfOneLine) - 1
        let height = (collectionViewHeight - minimumLineSpacing - topBottomMargin * 2) / 2 - 1
        
        flow.itemSize = CGSize(width: itemWidth, height: height)
        
        flow.sectionInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
        let tempCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tempCollectionView.bounces = false
        tempCollectionView.showsVerticalScrollIndicator = false
        tempCollectionView.backgroundColor = UIColor.whiteColor()
        tempCollectionView.registerClass(YNWatchCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Collection_Watch_product")
        self.view.addSubview(tempCollectionView)
        self.collectionView = tempCollectionView
    }
    
    //MARK: UICollectionViewDataSource 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return maxNumberOfWatch
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify = "Cell_Collection_Watch_product"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNWatchCollectionViewCell
        
        if indexPath.item < selectedArray.count {
        
            cell.productModel = selectedArray[indexPath.item]
        } else {
        
            cell.productModel = nil
        }
        
        return cell
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item < selectedArray.count {
        
            markDeselected(selectedArray[indexPath.item])
            
            selectedArray.removeAtIndex(indexPath.item)
            
            self.collectionView?.reloadData()
        }
        
    }
    
    func markDeselected(model: YNCategoryModel) {
    
        for var i = 0; i < productArray.count; i++ {
        
            if productArray[i].id == model.id {
            
                productArray[i].isSelected = false
                
                self.tableViewProduct?.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Middle)
                break
            }
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
        
            return self.cayegoryArray.count
            
        } else if tableView.tag == 2 {
        
            return self.productArray.count
        }
        
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
        
            let identify = "Cell_Catagory"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNCategoryTableViewCell
            
            if cell == nil {
                
                cell = YNCategoryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            }
            
            cell?.categoryModel = self.cayegoryArray[indexPath.row]
            
            return cell!
        }
        
        let identify = "Cell_Product"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNWatchProductTableViewCell
        
        if cell == nil {
            
            cell = YNWatchProductTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
        cell?.delegate = self
        cell?.productModel = self.productArray[indexPath.row]
        
        return cell!
        
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == 1 {
        
            let model = self.cayegoryArray[indexPath.row]
            model.isSelected = true
            
            self.tableViewCatagory?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            self.tableViewCatagory?.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            
            //发送网络请求二级数据
            loadHttpData(model.id, reloadData: .tableViewProduct)
            
        }
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == 1 {
        
            self.cayegoryArray[indexPath.row].isSelected = false
            self.tableViewCatagory?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            
        }
        
    }
    
    //MARK: YNWatchProductTableViewCellDelegate
    func watchProductTableViewCellSelectButtonDidClick(cell: YNWatchProductTableViewCell) {
        
    
            if cell.selectButton.selected {
                
                if selectedArray.count < maxNumberOfWatch {
                    
                    self.selectedArray.append(cell.productModel!)
                    self.collectionView?.reloadData()
                    
                    //TODO: 添加到个人关注上
                    updateUserWatchList()
                    
                } else {
                    
                    YNProgressHUD().showText("最多只能添加\(maxNumberOfWatch)个", toView: self.view)
                    cell.selectButton.selected = false
                    
                }
                
            
            } else {
                
                removeItemWithId(cell.productModel!.id)
                self.collectionView?.reloadData()
                
                //TODO: 删除个人关注
                 updateUserWatchList()
            }
            
        
    }
    
    
    //mark: 从selectArray中删掉取消的品类
    func removeItemWithId(id: String) {
    
        for var i = 0; i < selectedArray.count; i++ {
        
            if selectedArray[i].id == id {
            
                selectedArray.removeAtIndex(i)
                break
            }
        }
    }
    
    //MARK: 更新用户关注领域
    func updateUserWatchList() {
    
        let classId = markclassId()
        
        YNWatchHttp.updateQusetionClassWithClassId(classId, successFull: { (json) -> Void in
            
            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                   
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                    }
                }
                
            }

            
            }) { (error) -> Void in
               
                YNProgressHUD().showText("数据加载失败", toView: self.view)
        }
    }
    
    func markclassId()-> String {
        
        var classId = ""
        
        for var i = 0; i < selectedArray.count; i++ {
        
            if i == (selectedArray.count - 1) {
            
                classId += selectedArray[i].id
                
            } else {
            
                classId += selectedArray[i].id + ","
            }
        }
        
        return classId
    }
    
    //MARK: 加载网络数据
    func loadHttpData(parentId: String, reloadData: YNReloadDataType) {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpLoadCategory().getQuestionClassWithParentId(parentId, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
//            print(json)
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if reloadData == .tableViewCatagory {
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNCategoryModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.cayegoryArray.append(model)
                        }
                        
                        self.tableViewCatagory!.reloadData()
                        self.tableView(self.tableViewCatagory!, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                        
                    } else if reloadData == .tableViewProduct {
                        
                        self.productArray = [YNCategoryModel]()
                        
                        for item in tempdata {
                            
                            let model = YNCategoryModel(dict: item as! NSDictionary)
                            self.productArray.append(model)
                            
                        }
                        
                        //把选中的做上标记
                        self.markSelected()
                        
                        self.tableViewProduct!.reloadData()
                    }
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        YNProgressHUD().showText(msg, toView: self.view)
                        
                        print("\n \(msg) \n")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("请求失败", toView: self.view)
        }
        
    }
    
    
    func markSelected() {
        
        for var i = 0; i < selectedArray.count; i++ {
        
            for var j = 0; j < productArray.count; j++ {
            
                if productArray[j].id == selectedArray[i].id {
                
                    productArray[j].isSelected = true
                    break
                }
            }
        }
    }

    
}

