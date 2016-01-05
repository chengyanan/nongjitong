//
//  YNSearchResaultDetailViewController.swift
//  nongjitong
//
//  Created by 农盟 on 15/10/21.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit

class YNSearchResaultDetailViewController: UIViewController, UIWebViewDelegate {

    //MARK: - public proporty
    var searchresault: YNSearchResaultModel? {
    
        didSet {
        
            loadDetail()
        }
    
    }
    
    //MARK: - private proporty
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var serachResaultDetail: YNSearchResaultDetailModel? {

        didSet {
        
            self.titleLabel.text = serachResaultDetail!.title
            self.webView.loadHTMLString(self.serachResaultDetail!.content, baseURL: nil)
            
        }
    }
    
    var progress: ProgressHUD?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "文章详情"

        self.titleLabel.hidden = true
        
        self.webView.delegate = self
    }
    
    
    //MARK: - UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        
        self.progress = YNProgressHUD().showWaitingToView(self.view)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        self.progress!.hideUsingAnimation()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        YNProgressHUD().showText("\(error)", toView: self.view)
    }
    
    //MARK: private method
    func loadDetail() {
    
        let params = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "Search",
            "a": "doc",
            "id": self.searchresault?.id
        ]
        
        let progress = YNProgressHUD().showWaitingToView(self.view)
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            progress.hideUsingAnimation()
            
            let json: NSDictionary =  (try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            print("data - \(json)")
            
            if let status = json["status"] as? Int {
                
                if status == 1 {
                
                    let dict = json["data"] as! NSDictionary
                    
                    let resaultDetail = YNSearchResaultDetailModel(dict: dict)
                    self.serachResaultDetail = resaultDetail
                    
                    self.titleLabel.hidden = false
                    
                    
                } else if status == 0 {
                    
                    if let _ = json["msg"] as? String {
                        
                        YNProgressHUD().showText("没有文章详情", toView: self.view)
                    }
                }
                
            }
            
            }) { (error) -> Void in
                
                progress.hideUsingAnimation()
                YNProgressHUD().showText("加载失败", toView: self.view)
        }

    }
    
    
    //MARK: event response
    
    @IBAction func relatedQuestions(sender: AnyObject) {
        
        let vc = YNSearchResaultQuestionViewController()
        vc.docId = self.searchresault?.id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func solutionList(sender: AnyObject) {
        
        let vc = YNSearchResaultSolutionViewController()
         vc.solutionType = SolutionType.MyselfArticle
        vc.searchresault = self.searchresault
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
