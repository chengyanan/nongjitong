//
//  YNDocAlbumTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocAlbumTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.scrollDirection = .Horizontal
        
        let tempCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flow)
    
        tempCollectionView.pagingEnabled = true
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tempCollectionView.backgroundColor = UIColor.whiteColor()
        tempCollectionView.showsHorizontalScrollIndicator = false
        
        tempCollectionView.registerClass(YNDocAlbumCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Doc_album")
        
        self.collectionView = tempCollectionView
        
        contentView.addSubview(collectionView!)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        Layout().addTopConstraint(collectionView!, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(collectionView!, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView!, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(collectionView!, toView: self.contentView, multiplier: 1, constant: 0)
        
       
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "Cell_Doc_album"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! YNDocAlbumCollectionViewCell
        
//        cell?.imageUrl = 
        
        return cell
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return self.contentView.frame.size
        
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        
//        return 0.1
//    }
    
    
    
}
