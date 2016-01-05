//
//  YNResaultLoadModeCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/22.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNResaultLoadModeCell: UITableViewCell {

    var loadLable: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let loadLable = UILabel()
        loadLable.text = "加载更多数据"
        loadLable.font = UIFont.systemFontOfSize(13)
        loadLable.textAlignment = .Center
        self.loadLable = loadLable
        
        self.contentView.addSubview(loadLable)
        
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        loadLable!.frame = self.contentView.bounds
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
