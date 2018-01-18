//
//  YTTNetworkConfig.swift
//
//  Created by Andy on 2017/7/17.
//  Copyright © 2017年 AndyCuiYTT. All rights reserved.
//

import UIKit

class YTTNetworkConfig: NSObject {
    
    
    /// 请求超时时间
    class var timeoutInterval: TimeInterval {
        return 30
    }
    
    
    /// 基地址
    class var baseUrl: String {
        return ""
    }
    
    /// 缓存有效时间
    class var expirationTime: TimeInterval {
        return 3 * 60 * 60
    }
    
    /// 刷新缓存时间
    class var updateCacheTime: TimeInterval {
        return 20
    }
    
    
    class var configuration: URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    class var downloadPath: String {
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/download/")
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: path!) {
            try! fileManager.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
        }
        return path!
    }
    
    

    
    
    
    
}
