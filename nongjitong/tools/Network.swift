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
    
    //上传图片
    static func post(url: String, params: [String: String?], files: Array<File>,  success: (data: NSData!, response: NSURLResponse!, error: NSError?)->Void, failure: (error: NSError!)->Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let manager = NetworkManager(method: "POST", url: url, params: params, files: files, success: success, failure: failure)
            
            manager.fire()
        })
        
    }

    
    //加载图片
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
    
    //add files
    var files: Array<File>
    //指定的间隔符
    let boundary = "PitayaUGl0YXlh"
    
    init(method: String, url: String, params: [String: String?], files : Array<File> = [File](), success: (data: NSData, response: NSURLResponse, error: NSError?)->Void, failure: (error: NSError)->Void) {
   
        self.method = method
        self.url = url
        self.params = params
        self.success = success
        self.failure = failure
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        self.files = files
        
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
        
        let data = NSMutableData()
        
        if self.files.count > 0 {
        
            for (key, value) in self.params {
            
                data.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("\(value!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
            }
            
            for file in files {
                
                data.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.name).jpg\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                data.appendData(file.imageData)
                data.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
               
                
            }

            
            //            for file in files {
            //
            //                data.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            //
            //                data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(NSString(string: file.url.description).lastPathComponent)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            //
            //                if let a = NSData(contentsOfURL: file.url) {
            //                    data.appendData(a)
            //                    data.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            //                }
            //            
            //            }

            
            
            data.appendData("--\(self.boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
        } else if self.params.count > 0 && self.method != "GET" {
            
             data.appendData(buildParams(self.params).dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        request.HTTPBody = data
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
        
        if self.files.count > 0 {
        
            request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
            
        } else if self.params.count > 0 {
       
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        

    }
    
    // 从 Alamofire 偷了三个函数
    func buildParams(parameters: [String: String?]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            
            
            let value: AnyObject! = parameters[key]!
            
            if value != nil {
            
                components += queryComponents(key, value)
            }
            
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

//MARK: struct file
struct File {
    let name: String!
    let imageData: NSData!
    init(name: String, imageData: NSData) {
        self.name = name
        self.imageData = imageData
    }
}