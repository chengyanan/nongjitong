//
//  YNMembersTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/29.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNMembersTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    var dataArray = [YNMemberModel]() {
    
        didSet {
        
            self.collectionView.reloadData()
        }
    }
    
    static let numberOfItemsInOneLine: CGFloat = 5
    static let itemSpacing: CGFloat = 12
    
    static let topBottomInset: CGFloat = 30
    static let leftRightInset: CGFloat = 20
    
    
    let collectionView: UICollectionView = {
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.scrollDirection = .Vertical
        let width = (kScreenWidth - leftRightInset*2 - (numberOfItemsInOneLine - 1)*itemSpacing)/numberOfItemsInOneLine
        flowLayout.itemSize = CGSize(width: width, height: width + 20)
        
        
        let tempView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        tempView.contentInset = UIEdgeInsets(top: topBottomInset, left: leftRightInset, bottom: topBottomInset, right: leftRightInset)
        
        tempView.registerClass(YNMembersCollectionViewCell.self, forCellWithReuseIdentifier: YNMembersCollectionViewCell.identify)
        
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        return tempView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        
        Layout().addTopConstraint(collectionView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(collectionView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(collectionView, toView: contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(collectionView, toView: contentView, multiplier: 1, constant: 0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        if indexPath.item == 0 {
//        
//            //添加按钮
//        }
        
        //成员信息
        let identify = YNMembersCollectionViewCell.identify
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as? YNMembersCollectionViewCell
        
        cell?.model = self.dataArray[indexPath.item]
        
        return cell!
    }
    
    
    
    
}
