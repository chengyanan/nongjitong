//
//  UIImageViewExtension.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/3.
//  Copyright © 2015年 农盟. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func getImageWithURL(url: String, contentMode mode: UIViewContentMode) {
        guard
            let imageUrl = NSURL(string: url)
            else {return}
        
        contentMode = mode
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            NSURLSession.sharedSession().dataTaskWithURL(imageUrl, completionHandler: { (data, response, error) -> Void in
                
                guard
                    let imageData = data where error == nil,
                    let image = UIImage(data: imageData)
                    else {return}
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.image = image
                })
                
            }).resume()
            
        })

        
    }
    
    
}