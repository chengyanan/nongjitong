//
//  YNNewsTagsTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNNewsTagsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataArray = [String]() {
        
        didSet {
            
            self.collectionView.reloadData()
        }
    }
   
    let collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.scrollDirection = .Horizontal
        
        let tempView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        tempView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        
        tempView.registerClass(YNNewstagCollectionViewCell.self, forCellWithReuseIdentifier: YNNewstagCollectionViewCell.identify)
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.whiteColor()
        
        return tempView
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Layout().addTopConstraint(collectionView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(collectionView, toView: contentView, multiplier: 1, constant: 12)
        Layout().addRightConstraint(collectionView, toView: contentView, multiplier: 1, constant: -0)
        Layout().addBottomConstraint(collectionView, toView: contentView, multiplier: 1, constant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataArray.count > 0 {
            
            return dataArray.count
        }
        
        return 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YNNewstagCollectionViewCell.identify, forIndexPath: indexPath) as! YNNewstagCollectionViewCell
        
        cell.title = dataArray[indexPath.item]
        
        return cell
        
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let model = dataArray[indexPath.item]
        let width = widthForView(model, font: UIFont.systemFontOfSize(11))
        
        return CGSize(width: width + 18, height: 21)
        
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
