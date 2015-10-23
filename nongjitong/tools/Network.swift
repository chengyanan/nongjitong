//
//  Network.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/12.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

class Network {
    
    static func get(url: String, params: [String: String?], success: (data: NSData, response: NSURLResponse, error: NSError?)->Void, failure: (error: NSError)->Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let manager = NetworkManager(method: "GET", url: url, params: params, success: success, failure: failure)
            manager.fire()
        
        })
        
    }
    
    static func post(url: String, params: [String: String?], success: (data: NSData!, response: NSURLResponse!, error: NSError?)->Void, failure: (error: NSError!)->Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let manager = NetworkManager(method: "POST", url: url, params: params, success: success, failure: failure)
            manager.fire()
        })

    }
    
    static func getImageWithURL(url: String, success:(data: NSData)->Void) {
   
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let session = NSURLSession.sharedSession()
            
            session.dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    success(data: data!)
                })
                
                
            })
            
        })
    }
}

class NetworkManager {
    let method: String
    let url: String
    let params: [String: String?]
    let success: (data: NSData, response: NSURLResponse, error: NSError?)->Void
    let failure: (error: NSError)->Void
    let session = NSURLSession.sharedSession()
    var request: NSMutableURLRequest
    var task: NSURLSessionTask?
    
    init(method: String, url: String, params: [String: String?], success: (data: NSData, response: NSURLResponse, error: NSError?)->Void, failure: (error: NSError)->Void) {
   
        self.method = method
        self.url = url
        self.params = params
        self.success = success
        self.failure = failure
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
    }
    
    
    func fire() {
        buildRequest()
        buildBody()
        fireTask()
    }
    
    func fireTask() {
        
        task = session.dataTaskWithRequest(request, completionHandler: { (data , response, errer) -> Void in
           
            
            if let _ = errer {
           
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.failure(error: errer!)
                    
                })
                
            } else {
            
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.success(data: data!, response: response!, error: errer)
                    
                })
                
            }
            
            

        })
        
        task!.resume()
    }
    
    func buildBody() {
   
        if self.params.count > 0 && self.method != "GET" {
            request.HTTPBody = buildParams(self.params).dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
    
   
    func buildRequest() {
   
        
        if self.params.count > 0 {
            
            let tempUrl = url + "?" + buildParams(self.params)
            
            print("\(tempUrl)\n")
            
            self.request = NSMutableURLRequest(URL: NSURL(string: tempUrl)!)
        }
        
//        if self.method == "GET" && self.params.count>0 {
//       
//            let tempUrl = url + "?" + buildParams(self.params)
//            
//            print("\(tempUrl)\n", terminator: "")
//            
//            self.request = NSMutableURLRequest(URL: NSURL(string: tempUrl)!)
//        }
        
        request.HTTPMethod = self.method
        if self.params.count > 0 {
       
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

    }
    
    // 从 Alamofire 偷了三个函数
    func buildParams(parameters: [String: String?]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        let generalDelimiters = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimiters = "!$&'()*+,;="
        
        let legalURLCharactersToBeEscaped: CFStringRef = generalDelimiters + subDelimiters
        
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}