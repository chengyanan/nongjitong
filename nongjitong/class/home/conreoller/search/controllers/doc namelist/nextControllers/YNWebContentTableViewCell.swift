//
//  YNWebContentTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/1/20.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class YNWebContentTableViewCell: UITableViewCell, UIWebViewDelegate {

    
    var serachResaultDetail: YNSearchResaultDetailModel? {
        
        didSet {
            
            self.webView.loadHTMLString(self.serachResaultDetail!.content, baseURL: nil)
            
        }
        
    }

    
    let webView: UIWebView = {
    
        let tempView = UIWebView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
        
    }()
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.contentView.addSubview(webView)
        
        webView.delegate = self
        
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setLayout() {
        
        //webView
        Layout().addTopConstraint(webView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(webView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(webView, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(webView, toView: self.contentView, multiplier: 1, constant: 0)
        
        
    }
    
    
    var prograssHud: ProgressHUD?
    
    //MARK: UIWebViewDelegate
//    func webViewDidStartLoad(webView: UIWebView) {
//        
//        prograssHud = YNProgressHUD().showWaitingToView(self.contentView)
//        
//    }
//    func webViewDidFinishLoad(webView: UIWebView) {
//        
//        prograssHud?.hideUsingAnimation()
//    }
    
    
    
}
