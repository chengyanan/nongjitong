//
//  YNPhotoBrowerView.swift
//  nongjitong
//
//  Created by 农盟 on 16/2/19.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNPhotoBrowerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var cureentIndex = 1
    
    var firstIndex: Int?
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: firstIndex!-1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
    }
    
    var photos = [String]() {
    
        didSet {
        
            self.imageIndex.text = "1/\(self.photos.count)"
            self.collectionView?.reloadData()
        }
    }
    
    var collectionView: UICollectionView?
    let imageIndex: UILabel = {
        
        let tempView = UILabel()
        tempView.textAlignment = .Center
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.textColor = UIColor.whiteColor()
        
        return tempView
        
    }()
    
       override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.scrollDirection = .Horizontal
        
        let tempCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
        
        tempCollectionView.pagingEnabled = true
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tempCollectionView.backgroundColor = UIColor.clearColor()
        tempCollectionView.showsHorizontalScrollIndicator = false
        
        tempCollectionView.registerClass(YNPhotoBrowerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Photo_Brower")
        
        self.collectionView = tempCollectionView
        
        self.addSubview(collectionView!)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        Layout().addTopConstraint(collectionView!, toView: self, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(collectionView!, toView: self, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView!, toView: self, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(collectionView!, toView: self, multiplier: 1, constant: 0)
        
        let tgr = UITapGestureRecognizer(target: self, action: "removeMyselfFromSuperView")
        
        self.collectionView?.addGestureRecognizer(tgr)
        
        self.addSubview(imageIndex)
        Layout().addLeftConstraint(imageIndex, toView: self, multiplier: 1, constant: 10)
        Layout().addRightConstraint(imageIndex, toView: self, multiplier: 1, constant: -10)
        Layout().addBottomConstraint(imageIndex, toView: self, multiplier: 1, constant: -10)
        Layout().addHeightConstraint(imageIndex, toView: nil, multiplier: 0, constant: 20)
        
        
        
    }

    //MARK: event response
    func removeMyselfFromSuperView() {
    
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "Cell_Photo_Brower"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! YNPhotoBrowerCollectionViewCell
        
        let photo = Photo(title: "", url: self.photos[indexPath.item], index: indexPath.item)
        
        cell.photo = photo
        
        return cell
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return self.frame.size
        
    }
    
    //MARK: collectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.removeMyselfFromSuperView()
        
    }
    
    //MARK: scrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.photos.count > 0 {
            
            let offsetX = scrollView.contentOffset.x
            
            let halfWidth = kScreenWidth*0.5
            
            let width = kScreenWidth
            
            let index: Int = Int((offsetX + halfWidth) / width) + 1
            
            self.cureentIndex = index
            
            self.imageIndex.text = "\(index)/\(self.photos.count)"
            
        }
        
        
    }
    
    
    
}
