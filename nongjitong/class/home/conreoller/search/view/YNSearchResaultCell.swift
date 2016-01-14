//
//  YNSearchResaultCell.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/21.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit


class YNSearchResaultCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - public proporty
    var resault: YNSearchResaultModel? {
    
        didSet {
        
            self.titleLabel.text = resault?.title
            self.summaryLabel.text = Tools().removePresentEncoding(resault!.summary)
        
        }
    }
    
    //MARK: - private proporty
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
}
