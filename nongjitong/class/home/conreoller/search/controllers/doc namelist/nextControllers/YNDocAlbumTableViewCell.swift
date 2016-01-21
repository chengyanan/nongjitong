//
//  YNDocAlbumTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNDocAlbumTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var cureentIndex = 1
    
    var photos = [Photo]() {
    
        didSet {
        
            if photos.count > 0 {
            
                self.collectionView?.reloadData()
                
                self.imageIndex.text = "1/\(photos.count)  "
                
            } else {
            
                //没有图
                self.imageIndex.text = ""
                let photo = Photo(title: "没有图片", url: "", index: 1)
                
                photos.append(photo)
                self.collectionView?.reloadData()
                
            }
            
            
        }
    }
    
    var collectionView: UICollectionView?
    
    let imageIndex: UILabel = {
        
        let tempView = UILabel()
        tempView.textAlignment = .Right
        tempView.font = UIFont.systemFontOfSize(13)
        tempView.translatesAutoresizingMaskIntoConstraints = false
       
        tempView.textColor = UIColor(red: 27/225.0, green: 202/225.0, blue: 156/225.0, alpha: 1)
        
        return tempView
        
    }()
    
    
    let leftButton: UIButton = {
    
        let tempView = UIButton()
        tempView.setImage(UIImage(named: "sapi-nav-back-btn-bg"), forState: .Normal)
        tempView.backgroundColor = UIColor.clearColor()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.imageView?.contentMode = .ScaleToFill
        return tempView
    }()
    
    let rightButton: UIButton = {
        
        let tempView = UIButton()
        tempView.setImage(UIImage(named: "sapi-nav-back-btn-right"), forState: .Normal)
        tempView.backgroundColor = UIColor.clearColor()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.imageView?.contentMode = .ScaleToFill
        return tempView
    }()
    
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
        
       
        contentView.addSubview(imageIndex)
        //imageIndex
        Layout().addRightConstraint(imageIndex, toView: contentView, multiplier: 1, constant: -10)
        Layout().addBottomConstraint(imageIndex, toView: contentView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(imageIndex, toView: nil, multiplier: 0, constant: 20)
        Layout().addWidthConstraint(imageIndex, toView: contentView, multiplier: 1, constant: 60)
        
        //leftButton
        contentView.addSubview(leftButton)
        Layout().addLeftConstraint(leftButton, toView: contentView, multiplier: 1, constant: 10)
        Layout().addCenterYConstraint(leftButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(leftButton, toView: nil, multiplier: 0, constant: 16)
        Layout().addHeightConstraint(leftButton, toView: nil, multiplier: 0, constant: 24)
        
        //
        contentView.addSubview(rightButton)
        Layout().addCenterYConstraint(rightButton, toView: contentView, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(rightButton, toView: nil, multiplier: 0, constant: 16)
        Layout().addHeightConstraint(rightButton, toView: nil, multiplier: 0, constant: 60)
        Layout().addRightConstraint(rightButton, toView: contentView, multiplier: 1, constant: -10)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "Cell_Doc_album"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! YNDocAlbumCollectionViewCell
        
        cell.photo = self.photos[indexPath.item]
        
        return cell
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return self.contentView.frame.size
        
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
