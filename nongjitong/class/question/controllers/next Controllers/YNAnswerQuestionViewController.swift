//
//  YNAnswerQuestionViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/7.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNAnswerQuestionViewController: UIViewController {

    var questionModel: YNQuestionModel?
    
    init(questionModel:YNQuestionModel) {
        
       super.init(nibName: nil, bundle: nil)
       self.questionModel = questionModel
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(questionModel!.user_name)的提问"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sapi-nav-back-btn-bg"), style: .Plain, target: self, action: "popViewController")
        
        
        
//        setInterface()
//        setLayout()
    }
    
    
    func popViewController() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
