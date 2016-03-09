//
//  YNOtherLinkViewController.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/9.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit


enum OtherLinkType {

    case Nongmeng, Brand, Other
}

class YNOtherLinkViewController: UIViewController, UIWebViewDelegate {

    var type: OtherLinkType?
    
    
    let webView: UIWebView = {
        
        let tempView = UIWebView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
        
    }()
    
    init(type: OtherLinkType) {
    
        super.init(nibName: nil, bundle: nil)
        
        self.type = type
        
        self.hidesBottomBarWhenPushed = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(webView)
         webView.delegate = self
        
        setLayout()
        
        getLinks()
    }
    
    func setLayout() {
        
        //webView
        Layout().addTopConstraint(webView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addLeftConstraint(webView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addRightConstraint(webView, toView: self.view, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(webView, toView: self.view, multiplier: 1, constant: 0)

        
    }
    
    
    
    var prograssHud: ProgressHUD?
    
    //MARK: UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {

        prograssHud = YNProgressHUD().showWaitingToView(self.view)

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

        prograssHud?.hideUsingAnimation()
    }
    
    
    //MARK: 加载新闻分类
    func getLinks() {
        
        //已登陆请求数据
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Link",
            "a": "getLinks"
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        let temp = json["data"] as? NSDictionary
                        
                        
                        
                        switch self.type! {
                        
                        case .Nongmeng:
                        
                            
                            let url = temp!["nm"] as! String
                            
                            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60))
                            
                            break
                        case .Brand:
                        
                            let url = temp!["pp"] as! String
                            
                            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60))
                            
                            break
                        case .Other:
                        
                            let url = temp!["other"] as! String
                            
                            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60))
                            
                            break
                        
                        }
                            
                       
                        
                    } else if status == 0 {
                        
                        if let msg = json["msg"] as? String {
                            
                            //                            print(msg)
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                    }
                    
                }
                
            } catch {
                
                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
