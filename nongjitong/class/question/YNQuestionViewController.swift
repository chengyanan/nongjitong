//
//  YNQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/16.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNQuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let leftRightMargin: CGFloat = 10
    let itemSpacing: CGFloat = 3
    let tableViewHeight: CGFloat = 44
    let collectionEdgeInsetTopBottom: CGFloat = 12
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    //collectionViewdatasource
    var selectedArray = [YNSelectedProductModel]()
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupInterface()
        setLayout()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataFromServer()
    }
    
    //MARK: 数据加载
    func loadDataFromServer() {
        
        // 加载关注数据
        let progress = YNProgressHUD().showWaitingToView(self.view)
        YNWatchHttp.getUserSpecialty({ (json) -> Void in
            progress.hideUsingAnimation()
            
//            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        self.selectedArray.removeAll()
                        
                        let newmodel = YNSelectedProductModel()
                        newmodel.class_name = "最新"
                        newmodel.isSelected = true
                        self.selectedArray.append(newmodel)
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNSelectedProductModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.selectedArray.append(model)
                        }
                        
                        self.collectionView?.reloadData()
                        self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                        
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
        
    }
    
    //MARK: 设置界面
    func setupInterface() {
        
        //tableView
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
//        tempTableView.estimatedRowHeight = 44
//        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempTableView)
        self.tableView = tempTableView
        
        //collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        flow.itemSize = CGSize(width: 60, height: tableViewHeight - 1)
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
        Layout().addBottomConstraint(tableView!, toView: self.view, multiplier: 1, constant: -64)
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL_Question"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identify) as? YNQuestionTableViewCell
        
        if cell == nil {
        
            cell = YNQuestionTableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 180
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
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        model.isSelected = false
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
}