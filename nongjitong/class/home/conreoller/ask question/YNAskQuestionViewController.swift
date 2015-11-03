//
//  YNAskQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAskQuestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YNFinishInputViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let finishViewHeight: CGFloat = 40
    var finishView: YNFinishInputView?
    var collectionContentSize: CGSize?

    //上传的图片的最大数量
    let maxImageCount = 3
    
    
    var imageArray = [UIImage]()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置collectionView
        setupCollectionView()
        
        //添加跟随键盘出现的View
        addFinishView()
        
        //添加键盘通知
        addKeyBoardNotication()
        
        self.collectionContentSize = self.collectionView.contentSize
    }
    
    func addFinishView() {
    
        let finishView = YNFinishInputView()
        finishView.delegate = self
        finishView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, finishViewHeight)
        self.view.addSubview(finishView)
        
        self.finishView = finishView
        self.view.bringSubviewToFront(self.finishView!)
    }
    
    //MARK: YNFinishInputViewDelegate
    func finishInputViewFinishButtonDidClick() {
        
        //退出键盘
        hideKeyBoard()
    }
    
    
    func addKeyBoardNotication() {
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
        
            let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
//            print(keyboardBounds)
            
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            let keyboardBoundsRect = self.view.convertRect(keyboardBounds, toView: nil)

            let deltaY = keyboardBoundsRect.size.height + finishViewHeight
            
            print(self.collectionContentSize)
            
           self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, deltaY, 0)
            
            print(self.collectionView.frame)
        
//
//            print(self.collectionView.contentSize)
            
            let animations: (()->Void) = {
                
                self.finishView!.transform = CGAffineTransformMakeTranslation(0, -deltaY)
            }
            
            if duration > 0 {
                
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
                
                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
                
            } else {
                
                animations()
            }
            
            
        }
        
    
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
        
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animations:(() -> Void) = {
                self.finishView!.transform = CGAffineTransformIdentity
                
                self.collectionView.contentInset = UIEdgeInsetsZero
            }
            
            if duration > 0 {
                
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
                
            } else{
                
                animations()
            }
        }
        
    }
    
    func setupCollectionView() {
    
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNAskQuestionImageCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Image")
        
        self.collectionView.registerClass(YNAskQuestionLocationCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Location")
        
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16
        
        let size = CGSizeMake(self.view.frame.size.width, 100)
        print(size)
        
        //        flow.itemSize = size
        
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 12, 0)
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView.collectionViewLayout = flow
        
        self.collectionView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
        
//        self.collectionView.bounces = true
        
//        let tgr = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
//        
//        self.collectionView.addGestureRecognizer(tgr)
    }
    
    func hideKeyBoard() {
    
        self.view.endEditing(true)
    }
    
    //MARK: event response
    @IBAction func cancle(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
        
            return CGSizeMake(self.view.frame.size.width, 120)
            
        } else if indexPath.section == 2 {
        
            return CGSizeMake(self.view.frame.size.width, 50)
        }
        
        return CGSizeMake(120, 120)
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 3
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 1 {
        
            if self.imageArray.count >= maxImageCount {
            
                return maxImageCount
            }
            
            return self.imageArray.count + 1
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
        
            let identify = "Cell_Ask_Qustion_text"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionTextCollectionViewCell
            
            return cell
            
        } else if indexPath.section == 2 {
        
            let identify = "Cell_Ask_Qustion_Location"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionLocationCollectionViewCell
            
            return cell
            
        }
        
        
        let identify = "Cell_Ask_Qustion_Image"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNAskQuestionImageCollectionViewCell
        
       
        
        if indexPath.item  == self.imageArray.count {
            
            //添加上传图片的照相机图标
            cell.cameraImage = UIImage(named: "home_ask_question_camera")

            
        } else {
        
              cell.image = self.imageArray[indexPath.item]
        }
        
        
        
        return cell
    }
    
}
