//
//  YNUserIntroduceViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/24.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNUserIntroduceViewController: UIViewController {

    
    var model: YNNearByModel? {
    
        didSet {
        
            self.title = "\(model!.user_name!)的主页"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    
    
}
