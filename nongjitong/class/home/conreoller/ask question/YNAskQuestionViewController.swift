//
//  YNAskQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/1.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAskQuestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let maxImageCount = 3
    
    var imageArray = [UIImage]()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.registerClass(YNAskQuestionTextCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Ask_Qustion_text")
        
        self.collectionView.registerClass(YNAskQuestionImageCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Image")
        
        self.collectionView.registerClass(YNAskQuestionLocationCollectionViewCell.self , forCellWithReuseIdentifier: "Cell_Ask_Qustion_Location")
        
        let flow = UICollectionViewFlowLayout()
        
        flow.minimumInteritemSpacing = 6
        flow.minimumLineSpacing = 16
        
        let size = CGSizeMake(self.view.frame.size.width, 100)
        print(size)
        
//        flow.itemSize = size
        
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 30, 0)
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView.collectionViewLayout = flow
        
        self.collectionView.backgroundColor = kRGBA(234, g: 234, b: 234, a: 1)
        
        self.collectionView.bounces = true
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
        
       
        
        if indexPath.item == self.imageArray.count + 1 {
            
            //TODO: 添加图片的Image
//                cell.image
            
        } else {
        
              cell.image = self.imageArray[indexPath.item]
        }
        
        
        
        return cell
    }
    
}
