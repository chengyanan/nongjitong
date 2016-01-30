//
//  YNCircleDetailModel.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/29.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

class YNCircleDetailModel: YNCircleModel {
    
    var users = [YNMemberModel]()
    
    var membersHeight: CGFloat = 44
    
    override init(dict: NSDictionary) {
        
        super.init(dict: dict)
        
        let tempArray = dict["users"] as? NSArray
        
        for item in tempArray! {
        
            let model = YNMemberModel(dict: item as! NSDictionary)
            
            self.users.append(model)
            
        }
        
        
        let width = (kScreenWidth - YNMembersTableViewCell.leftRightInset*2 - (YNMembersTableViewCell.numberOfItemsInOneLine - 1)*YNMembersTableViewCell.itemSpacing)/YNMembersTableViewCell.numberOfItemsInOneLine
        
        let height = width + 20
        
        //用floor, ceil,或者round
        
        let floatLines =  CGFloat(tempArray!.count + 1) / YNMembersTableViewCell.numberOfItemsInOneLine
        
        let  intLines = ceil(floatLines)
        
        self.membersHeight = intLines * height + (intLines - 1)*YNMembersTableViewCell.itemSpacing + YNMembersTableViewCell.topBottomInset*2
        
//        print(width, height, floatLines, intLines, membersHeight)
        
    }
    
    
    
    
}