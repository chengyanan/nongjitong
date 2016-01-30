//
//  YNCircleChatListViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/30.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNCircleChatListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var model: YNCircleModel? {
        
        didSet {
            
            self.title = model?.title!
        }
    }
    let leftRightMargin: CGFloat = 10
    let itemSpacing: CGFloat = 3
    let tableViewHeight: CGFloat = 44
    let collectionEdgeInsetTopBottom: CGFloat = 12
    
    var collectionView: UICollectionView?
    //collectionViewdatasource
    var selectedArray: [YNSelectedProductModel] = {
        
        let model1 = YNSelectedProductModel(id: "1", name: "通知")
        let model2 = YNSelectedProductModel(id: "2", name: "销售")
        let model3 = YNSelectedProductModel(id: "3", name: "采购")
        let model4 = YNSelectedProductModel(id: "4", name: "分成")
        let model5 = YNSelectedProductModel(id: "5", name: "台帐")
        let model6 = YNSelectedProductModel(id: "6", name: "意见")
        
        return [model1, model2, model3, model4, model5, model6]
    }()
    
    //tableviewDatasource
    var tableViewDataArray = [YNQuestionModel]()
    
    var currentClassIdIndex: Int = 0
    
    //加载当前的页数
    var pageCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_InfoMulti"), style: .Plain, target: self, action: "rightItemClick")
        
        setCollection()
        setLayout()
    }
    
    
    //MARK: event response
    func rightItemClick() {
    
        //进入详细页面
        let vc = YNCircleDetailsViewController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func setLayout() {
    
        //collectionView
        Layout().addTopConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 64)
        Layout().addLeftConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView!, toView: self.view, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(collectionView!, toView: nil, multiplier: 0, constant: 44)
    }
    
    func setCollection() {
    
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
    
    
}
