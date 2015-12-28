//
//  YNUserIntroduceViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/24.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNUserIntroduceViewController: UITableViewController {
    
    
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var nickNamelabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    
    @IBOutlet var areaLabel: UILabel!
    
    @IBOutlet var phoneLabel: UILabel!
    
    var model: YNNearByModel? {
    
        didSet {
        
            self.title = "\(model!.user_name!)的主页"
            
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = 36
        self.nickNamelabel.text = ""
        self.roleLabel.text = ""
        self.areaLabel.text = ""
        self.phoneLabel.text = ""
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = self.model {
        
            if let _ = model!.avatar {
                
                self.avatarImageView.getImageWithURL(model!.avatar!, contentMode: .ScaleAspectFill)
            }
            
            self.nickNamelabel.text = model!.user_name!
            
            self.roleLabel.text = model!.role!
            
            self.areaLabel.text = model!.area!
            self.phoneLabel.text = model!.mobile!
        }
    }
    

    
}
