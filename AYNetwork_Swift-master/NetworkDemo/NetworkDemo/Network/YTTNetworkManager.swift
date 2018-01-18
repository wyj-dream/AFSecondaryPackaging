//
//  YTTNetworkManager.swift
//
//  Created by Andy on 2017/7/17.
//  Copyright © 2017年 AndyCuiYTT. All rights reserved.
//


/**
 *  系统网络请求封装
 */
import UIKit

class YTTNetworkManager: NSObject {
    
    static var netStatus: Reachability.NetworkStatus = (Reachability()?.currentReachabilityStatus)!
    static let reachability = Reachability()
    
    class func getNetStatus() -> Void{
        
        reachability?.whenReachable = { reachability in
            if reachability.isReachableViaWiFi {
                netStatus = .reachableViaWiFi
            }else if reachability.isReachableViaWWAN {
                netStatus = .reachableViaWWAN
            }else if reachability.isReachable {
                netStatus = .notReachable
            }
            print(YTTNetworkManager.netStatus)
        }
        reachability?.whenUnreachable = { reachability in
            netStatus = .notReachable
            print(YTTNetworkManager.netStatus)
        }
        
        do {
            try reachability?.startNotifier()
        } catch  {
            print("Unable to start notifier")
        }
        
    }
    
    
    /// post 请求
    ///
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - params: 请求参数
    ///   - isCache: 是否需要缓存
    ///   - result: 返回结果
    ///   - fail: 失败
    class func post(_ urlStr: String, params: [String : String], isCache: Bool = false, result: @escaping (Any) -> Void, fail: @escaping (Any) -> Void) {
        
        if isCache {
            if let cacheResult = YTTNetworkCache.shareInstance().getResult(self.dicToMD5Str(params)) {
                if let value = try? JSONSerialization.jsonObject(with: cacheResult.data(using: .utf8)!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (cacheResult)
                }
                return
            }
        }
        
        var request = URLRequest(url: URL(string: urlStr)!)
        request.timeoutInterval = YTTNetworkConfig.timeoutInterval
        request.httpMethod = "POST"
        var paramStr = String()
        for (key , value) in params {
            paramStr.append("\(key)=\(value)&")
        }
        paramStr.remove(at: paramStr.index(before: paramStr.endIndex))
        request.httpBody = paramStr.data(using: .utf8)
        let session = URLSession(configuration: YTTNetworkConfig.configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if isCache {
                    YTTNetworkCache.shareInstance().addResult(self.dicToMD5Str(params), result: String.init(data: data!, encoding: .utf8)!, date: Date().timeIntervalSince1970.advanced(by: YTTNetworkConfig.expirationTime), verify: YTTNetworkCache.MD5(String.init(data: data!, encoding: .utf8)!))
                }
                if let value = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (String.init(data: data!, encoding: .utf8)!)
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
    
    
    /// get 请求
    ///
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - params: 请求参数    
    ///   - isCache: 是否需要缓存
    ///   - result: 返回结果
    ///   - fail: 失败
    class func get(_ urlStr: String, params: [String : String], isCache: Bool = false, result: @escaping (Any) -> Void, fail: @escaping (Any) -> Void) {
        
        // 查看缓存区，看是否有该数据缓存
        if isCache {
            if let cacheResult = YTTNetworkCache.shareInstance().getResult(self.dicToMD5Str(params)) {
                if let value = try? JSONSerialization.jsonObject(with: cacheResult.data(using: .utf8)!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (cacheResult)
                }
                return
            }
        }

        
        var paramStr = String()
        for (key , value) in params {
            paramStr.append("\(key)=\(value)&")
        }
        
        paramStr.remove(at: paramStr.index(before: paramStr.endIndex))
        var request = URLRequest.init(url: URL(string: urlStr + "?" + paramStr)!)
        request.timeoutInterval = YTTNetworkConfig.timeoutInterval
        request.timeoutInterval = YTTNetworkConfig.timeoutInterval
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: YTTNetworkConfig.configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if isCache {
                    YTTNetworkCache.shareInstance().addResult(self.dicToMD5Str(params), result: String.init(data: data!, encoding: .utf8)!, date: Date().timeIntervalSince1970.advanced(by: YTTNetworkConfig.expirationTime), verify: YTTNetworkCache.MD5(String.init(data: data!, encoding: .utf8)!))
                }
                if let value = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (String.init(data: data!, encoding: .utf8)!)
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
    
    
    
    /// 文件下载
    ///
    /// - Parameters:
    ///   - urlStr: 下载地址
    ///   - fileName: 文件名
    ///   - result: 文件缓存路径
    ///   - fail: 失败
    class func download(_ urlStr: String, fileName: String, result: @escaping (String) -> Void, fail: @escaping (Any) -> Void) {
        
        let request = URLRequest.init(url: URL(string: urlStr)!)
        let session = URLSession(configuration: YTTNetworkConfig.configuration)
        let task = session.downloadTask(with: request) { (pathUrl, response, error) in
            if error == nil {
                if let filePath: String = pathUrl?.path {
                    let fileManager = FileManager()
                    try! fileManager.moveItem(atPath: filePath, toPath: YTTNetworkConfig.downloadPath.appending("\(Date().timeIntervalSince1970)"+fileName))
                    result(YTTNetworkConfig.downloadPath.appending("\(Date().timeIntervalSince1970)"+fileName))
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
    
    
    /// 仿 form 表单多文件上传
    ///
    /// - Parameters:
    ///   - urlStr: 上传文件路径
    ///   - params: 请求参数
    ///   - filesData: 文件数据
    ///   - fileName: 文件名
    ///   - fileExtensions: 文件扩展名
    ///   - contentType: 文件类型
    ///   - result: 返回数据
    ///   - fail: 失败
    class func upload(_ urlStr: String, params: [String : String], filesData: [Data], fileName: String, fileExtensions:String, contentType: String,result: @escaping (Any) -> Void, fail: @escaping (Any) -> Void) {
        let boundary = "*****" // 分界标识
        var bodyData = Data()
        
        // 添加普通参数
        for (key , value) in params {
            bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition:form-data;name=\"\(key)\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type:text/plain;charset=utf-8\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(value)".data(using: .utf8)!)
        }
        
        // 添加文件数据
        for i in 0 ..< filesData.count {
            bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition:form-data; name=\"file\";filename=\(fileName)-\(i).\(fileExtensions)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
            bodyData.append(filesData[i])
        }
        bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // 设置 request
        var request = URLRequest(url: URL(string: urlStr)!)
        request.addValue("multipart/form-data;boundary=\"\(boundary)\";charset=\"UTF-8\"", forHTTPHeaderField: "Content-Type")
        request.addValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.timeoutInterval = YTTNetworkConfig.timeoutInterval
        
        // 发起请求
        let session = URLSession(configuration: YTTNetworkConfig.configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let value = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (String.init(data: data!, encoding: .utf8)!)
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
}


extension YTTNetworkManager {
    
    private class func dicToJSONString(_ dic: [String : String]) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        return String.init(data: jsonData, encoding: .utf8)!
    }
    
    fileprivate class func dicToMD5Str(_ dic: [String : String]) -> String {
        return YTTNetworkCache.MD5(self.dicToJSONString(dic))
    }
    
    
}



