//
//  YNCreatVoteViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/17.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNCreatVoteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,YNAskQuestionTextCollectionViewCellDelegate, YNTitleCollectionViewCellDelegate {

    
    var groupId: String?
    
    init(group_id: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        
        self.groupId = group_id
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //描述
    var textViewText: String?
    
    //标题
    var textTitle: String?
    
    var collectionView: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16
        
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 12, 0)
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let tempView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        
        tempView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
        
        return tempView
        
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "新建投票"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "sendButtonClick")
        
        
        //设置collectionView
        setupCollectionView()

        
    }
    
    
    
    
    func setupCollectionView() {
        
        self.collectionView.frame = self.view.bounds
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.addSubview(collectionView)
        
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNAskQuestionImageCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Image")
        
        self.collectionView.registerClass(YNAskQuestionExplianCollectionCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_explain")
        self.collectionView.registerClass(YNTitleCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_title")
        
    }
    
    //MARK: event response
    
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func sendButtonClick() {
        
        self.view.endEditing(true)
        
        if self.textViewText == nil || self.textViewText == "" {
            
            YNProgressHUD().showText("请输入描述", toView: self.view)
            
        } else {
            
            //判断是否登录
            if let _ = kUser_ID() as? String {
                
                //已登陆， 有方案上传
//                sendDataToserver()
                
            } else {
                
                //未登录
                let signInVc = YNSignInViewController()
                let signInNaVc = UINavigationController(rootViewController: signInVc)
                self.presentViewController(signInNaVc, animated: true, completion: { () -> Void in
                    
                })
                
            }
            
            
        }
        
    }
    
//    func sendDataToserver() {
//        
//        let userId = kUser_ID() as? String
//        
//        let params: [String: String?] = ["m": "Appapi",
//            "key": "KSECE20XE15DKIEX3",
//            "c": "Thread",
//            "a": "create",
//            "group_id": groupId,
//            "user_id": userId,
//            "descript": self.textViewText,
//            "title":self.textTitle
//        ]
//        
//        let progress = YNProgressHUD().showWaitingToView(self.view)
//        
//        Network.post(kURL, params: params, files: self.uploadImageFilesArray, success: { (data, response, error) -> Void in
//            
//            progress.hideUsingAnimation()
//            
//            let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//            
//            //            print("data - \(json)")
//            
//            if let status = json["status"] as? Int {
//                
//                if status == 1 {
//                    
//                    //                    print("写方案成功")
//                    
//                    
//                    YNProgressHUD().showText("创建成功", toView: self.view)
//                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//                        
//                        self.navigationController?.popViewControllerAnimated(true)
//                    }
//                    
//                    
//                } else if status == 0 {
//                    
//                    
//                    if let msg = json["msg"] as? String {
//                        
//                        
//                        YNProgressHUD().showText(msg, toView: self.view)
//                        
//                        
//                    }
//                }
//                
//            }
//            
//            
//            }) { (error) -> Void in
//                
//                
//                progress.hideUsingAnimation()
//                
//                YNProgressHUD().showText("数据上传失败", toView: self.view)
//                
//        }
//        
//        
//        
//        
//    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSizeMake(self.view.frame.size.width, 60)
            
        } else if indexPath.section == 1 {
            
            return CGSizeMake(self.view.frame.size.width, 120)
        }
    
        
        return CGSizeMake(self.view.frame.size.width, 44)
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 3
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let identify = "Cell_Ask_Qustion_title"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNTitleCollectionViewCell
            cell.delegate = self
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let identify = "Cell_Ask_Qustion_text"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionTextCollectionViewCell
            cell.delegate = self
            cell.inputTextView.placeHolder = "请输入描述"
            return cell
        }
        
        
        let identify = "Cell_Ask_Qustion_text"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionTextCollectionViewCell
        
        cell.inputTextView.placeHolder = "请输入选项"
        
        return cell
    }
    
    
    //MARK: YNAskQuestionTextCollectionViewCellDelegate
    func askQuestionTextCollectionViewCellTextViewDidEndEditing(text: String) {
        
        self.textViewText = text
    }
    
    //MARK: YNTitleCollectionViewCellDelegate
    func titleCollectionViewCell(cell: YNTitleCollectionViewCell, text: String) {
        
        self.textTitle = text
        
    }
    
    //MARK: property
    var askQuestionModel = YNAskQuestionModel()
    
    //上传的图片的最大数量
    let maxImageCount = 3
    
    var dataImageArray = [NSData]()
    
    var tempImageArray = [UIImage]()
    
    var imageArray = [UIImage]() {
        
        didSet {
            
            self.collectionView.reloadSections(NSIndexSet(index: 2))
        }
    }
    
    
    
    
}
