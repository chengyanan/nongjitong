//
//  YNDocNameListViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/18.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocNameListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var page: Int = 1
    var page_size: Int = 30
    var moreWidth: CGFloat = 25
    var marinLeftRight: CGFloat = 20
    
    var collectionViewLeftRightInset: CGFloat {
        
        var temp: CGFloat = 0
        var margin: CGFloat = 0
        
        if self.catagoryDataArray.count > 0 {
            
            for item in self.catagoryDataArray {
                
                let width = widthForView(item.name!, font: UIFont.systemFontOfSize(17))
                
                temp += width + moreWidth
            }
            
            let distant = self.view.frame.size.width - marinLeftRight*2 - temp
            
            if  distant > 0 {
                
                margin = (self.view.frame.size.width - temp) * 0.5
                
            } else {
                
                margin = marinLeftRight
            }
            
        }
        
        return margin
    }
    let itemSpacing: CGFloat = 6
    
    let catagoryCollectionViewHeight: CGFloat = 50
    var classId: String?
    var catagoryCollectionView: UICollectionView?
    
    var catagoryDataArray = [YNSearchCatagoryModel]() {
    
        didSet {
        
            setupInterface()
            //默认选中第一个
            self.catagoryCollectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
        }
    }
    
    var docListCollectionView: UICollectionView?
    var docListArray = [YNSearchResaultModel]()
    var docItemSize = CGSizeZero
    
    var cid: String?
    
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
        
        self.title = "方案"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
//        setupInterface()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.loadDataWithId(cid!)
    }

    
    func setupInterface() {
    
       
        setCatagoryCollectionView()
        setDocListCollectionView()
 
    }
    
    func setDocListCollectionView() {
    
        // 文章列表collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.sectionInset = UIEdgeInsets(top: 10, left: marinLeftRight*0.5, bottom: 0, right: marinLeftRight*0.5)
        flow.scrollDirection = .Vertical
    
        let itemWidth = (self.view.frame.size.width - marinLeftRight - itemSpacing*2)/3 - 1
        let itemHeight: CGFloat = 38
        docItemSize = CGSizeMake(itemWidth, itemHeight)
        
        let y = CGRectGetMaxY(self.catagoryCollectionView!.frame)
        let height = self.view.frame.size.height - y
        
        let tempCollectionView = UICollectionView(frame: CGRectMake(0, y, self.view.frame.size.width, height), collectionViewLayout: flow)
        tempCollectionView.tag = 2
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        
        tempCollectionView.registerClass(YNDocListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Collection_doc_List")
        
//        tempCollectionView.showsVerticalScrollIndicator = false
        tempCollectionView.scrollEnabled = true
        self.view.addSubview(tempCollectionView)
        self.docListCollectionView = tempCollectionView
        
        self.docListCollectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    func setCatagoryCollectionView() {
    
        //分类collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.sectionInset = UIEdgeInsets(top: 8, left: collectionViewLeftRightInset, bottom: 8, right: collectionViewLeftRightInset)
        flow.scrollDirection = .Horizontal
        
        let tempCollectionView = UICollectionView(frame: CGRectMake(0, 64, self.view.frame.size.width, catagoryCollectionViewHeight), collectionViewLayout: flow)
        tempCollectionView.tag = 1
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        
        tempCollectionView.backgroundColor = kRGBA(244, g: 244, b: 244, a: 0.8)
        
        tempCollectionView.registerClass(YNCatagoryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Collection_catagory_List")
        
        tempCollectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tempCollectionView)
        self.catagoryCollectionView = tempCollectionView
        
        
        let tempBounces = CGRectMake(0, 0, marinLeftRight*0.5, catagoryCollectionViewHeight*0.5)
        let centerY = tempCollectionView.center.y
        let leftCanterX = marinLeftRight*0.75
        
        indicationLeftImage.center = CGPointMake(leftCanterX, centerY)
        indicationLeftImage.bounds = tempBounces
        self.view.addSubview(indicationLeftImage)
        
        let rightCenterX = self.view.frame.size.width - marinLeftRight*0.75
        indicationRightImage.center = CGPointMake(rightCenterX, centerY)
        indicationRightImage.bounds = tempBounces
        self.view.addSubview(indicationRightImage)
    }
    
    //MARK:UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
        
            return catagoryDataArray.count
            
        } else if collectionView.tag == 2 {
        
            return docListArray.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
        
            let identify = "Cell_Collection_catagory_List"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNCatagoryCollectionViewCell
            
            cell.model = catagoryDataArray[indexPath.item]
            
            return cell
        }
        
        let identify = "Cell_Collection_doc_List"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNDocListCollectionViewCell
        
        cell.model = docListArray[indexPath.item]

        return cell
        
    }
    
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
        
            let model = catagoryDataArray[indexPath.item]
            let width = widthForView(model.name!, font: UIFont.systemFontOfSize(17))
            
            return CGSize(width: width + moreWidth, height: catagoryCollectionViewHeight - 12)
        }
       
        return docItemSize
        
    }
    
    //MARK: collectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView.tag == 1 {
        
            let model = self.catagoryDataArray[indexPath.item]
            
            if !model.isSelected {
            
                model.isSelected = true
                
                self.classId = model.cid
                
                //加载新数据
                getDocList(model.cid!)
                
                collectionView.reloadItemsAtIndexPaths([indexPath])
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
                
            }
         
            
        } else if collectionView.tag == 2 {
        
            //进入文章详情页面
            
            let vc = YNDocDetailsViewController()
            vc.searchresault = self.docListArray[indexPath.item]
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView.tag == 1 {
        
            let model = self.catagoryDataArray[indexPath.item]
            model.isSelected = false
            
            collectionView.reloadItemsAtIndexPaths([indexPath])
        }
        
       
    }
    
    
    func loadDataWithId(cid: String) {
    
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Search",
            "a": "getCategory",
            "parent_id": cid
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
                        
                            var tempArray = [YNSearchCatagoryModel]()
                            
                            for var i = 0; i < resaultData.count; i++ {
                                
                                let model = YNSearchCatagoryModel(dict: resaultData[i] as! NSDictionary)
                                
                                tempArray.append(model)
                                
                                if i == 0 {
                                
                                    //加载文章数据
                                    self.getDocList(model.cid!)
                                    
                                    model.isSelected = true
                                }
                                
                            }
                        
                        self.catagoryDataArray = tempArray
                       

                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("该分类下暂时还没有数据", toView: self.view)
                        
                        
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
    
    //MARK: 加载文章列表
    func getDocList(cid: String) {
        
        let params: [String: String?] = ["m": "Appapi",
        "key": "KSECE20XE15DKIEX3",
        "c": "Search",
        "a": "getCatDocs",
        "cid": cid,
        "page": String(page),
        "page_size": "\(page_size)"
        ]
        
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            //                print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                    
                    let resaultData = json["data"] as! NSArray
                    
                    if resaultData.count > 0 {
                        
                        for item in resaultData {
                            
                            let dict = item as! NSDictionary
                            
                            let resaultModel = YNSearchResaultModel(dict: dict)
                            
                            self.docListArray.append(resaultModel)
                        }
                        
                       
                        self.docListCollectionView?.reloadData()
                        
                        
                    } else {
                        
                        //没数据
                        YNProgressHUD().showText("没有数据啦", toView: self.view)
                        
                        self.docListArray.removeAll()
                        self.docListCollectionView?.reloadData()
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
    
    
    func widthForView(text:String, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, CGFloat.max))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
   
    let indicationLeftImage: UIImageView = {
    
        let tempView = UIImageView(image: UIImage(named: "sapi-nav-back-btn-bg"))
        tempView.contentMode = .ScaleToFill
        tempView.backgroundColor = UIColor.clearColor()
        return tempView
        
    }()
    
    let indicationRightImage: UIImageView = {
        
        let tempView = UIImageView(image: UIImage(named: "sapi-nav-back-btn-right"))
        tempView.contentMode = .ScaleToFill
        tempView.backgroundColor = UIColor.clearColor()
        return tempView
        
    }()
    
    
    
}
