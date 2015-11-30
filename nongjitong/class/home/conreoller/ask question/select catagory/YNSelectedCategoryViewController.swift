//
//  YNSelectedCategoryViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/6.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

protocol YNSelectedCategoryViewControllerDelegate {

    func selectedCategoryDidSelectedProduct(product: YNCategoryModel)
}

class YNSelectedCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum YNReloadData {
        case TableView, CollectionView
    }
    
    //MARK: public protory
    var delegate: YNSelectedCategoryViewControllerDelegate?
    
    let tableViewWidthPercent: CGFloat = 0.33
    let numbersOfOneLine = 3
    let leftRightMargin: CGFloat = 10
    let itemSpacing: CGFloat = 3
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    //tableView数据源
    var cayegoryArray = [YNCategoryModel]()
    //collectionView数据源
    var productArray = [YNCategoryModel]()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //加载数据
        loadHttpData("0", reloadData: .TableView)
        
        setupInterface()
        setLayout()
    }
    
    //MARK: 加载网络数据
    func loadHttpData(parentId: String, reloadData: YNReloadData) {
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNHttpLoadCategory().getQuestionClassWithParentId(parentId, successFull: { (json) -> Void in
            
            progress.hideUsingAnimation()
            
            print(json)
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if reloadData == .TableView {
                        
                        for var i = 0; i < tempdata.count; i++ {
                        
                            let model = YNCategoryModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.cayegoryArray.append(model)
                        }
                        
                        self.tableView!.reloadData()
                        self.tableView(self.tableView!, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                        
                    } else if reloadData == .CollectionView {
                        
                        self.productArray = [YNCategoryModel]()
                        
                        for item in tempdata {
                            
                            let model = YNCategoryModel(dict: item as! NSDictionary)
                            self.productArray.append(model)
                            
                        }
                        
                        self.collectionView!.reloadData()
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
    
    //MARK: 设置界面
    func setupInterface() {
    
        //tableView
        let tempTableView = UITableView()
        tempTableView.tableFooterView = UIView()
        tempTableView.rowHeight = 50
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        //collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.minimumLineSpacing = 20
        
        let collectionWidth: CGFloat = self.view.frame.size.width * (1 - tableViewWidthPercent)
        
        let space = CGFloat(numbersOfOneLine - 1) * itemSpacing
        
        let itemWidth = (collectionWidth - leftRightMargin*2 - space) / CGFloat(numbersOfOneLine) - 1
        
        flow.itemSize = CGSize(width: itemWidth, height: 30)
        
        flow.sectionInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        
        
        let tempCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tempCollectionView.backgroundColor = UIColor.whiteColor()
        tempCollectionView.registerClass(YNProductCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Collection_product")
        tempCollectionView.alwaysBounceVertical = true
        self.view.addSubview(tempCollectionView)
        self.collectionView = tempCollectionView
        
    }
    
    //MARK: 设置布局
    func setLayout() {
        
         //tableView
        Layout().addTopConstraint(tableView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(tableView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(tableView!, toView: nil, multiplier: 0, constant: self.view.frame.size.width * tableViewWidthPercent)
        
        //collectionView
        Layout().addTopConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addRightConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(collectionView!, toView: tableView!, multiplier: 1, constant: 0)
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cayegoryArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "Cell_Catagory"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNCategoryTableViewCell
        
        if cell == nil {
        
            cell = YNCategoryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        
       cell?.categoryModel = self.cayegoryArray[indexPath.row]
        
        return cell!
        
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let model = self.cayegoryArray[indexPath.row]
        model.isSelected = true
        
        self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        self.tableView?.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        
        //发送网络请求二级数据
        loadHttpData(model.id, reloadData: .CollectionView)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.cayegoryArray[indexPath.row].isSelected = false
        self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify = "Cell_Collection_product"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNProductCollectionViewCell
        
        cell.productModel = self.productArray[indexPath.item]

        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //把选的数据传给上个页面
        self.delegate?.selectedCategoryDidSelectedProduct(self.productArray[indexPath.item])
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
