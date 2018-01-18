//
//  AYNetworkManager.swift
//  AYNetwork_Swift
//
//  Created by Andy on 2017/6/7.
//  Copyright © 2017年 Andy. All rights reserved.
//


/**
 *  github:https://github.com/AndyCuiYTT/AYNetwork_Swift.git
 *
 *  该类基于 Alamofire ,使用时请先导入 Alamofire 库
 *
 *  该类所有方法均为静态方法,使用时不用实例化对象,可直接调用
 *
 *  如果与 HandyJSON 结合使用,将 responseJSON 换为 responseString
 */

import UIKit
import Alamofire

public typealias ayParams = [String : String]

class AYNetworkManager: NSObject {
    
    
    
    /// post 请求
    ///
    /// 服务器端返回数据为 JSON 数据格式
    /// - Parameters:
    ///   - urlStr: 请求网络地址
    ///   - params: 请求参数
    ///   - result: 成功返回数据
    ///   - fail: 失败返回数据
    static func ay_post(_ urlStr: String, _ params: ayParams? = nil, result: @escaping (Any)->Void, fail: @escaping (Any)->Void){
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                result(response.result.value!)
            }else{
                fail(response.error?.localizedDescription ?? "Error");
            }
        }
    }
    
    
    /// get 请求
    ///
    /// 服务器端返回数据为 JSON 数据格式
    /// - Parameters:
    ///   - urlStr: 请求网络地址
    ///   - params: 请求参数
    ///   - result: 请求成功返回数据
    ///   - fail: 请求失败返回数据
    static func ay_get(_ urlStr: String, _ params: ayParams? = nil, result: @escaping (Any)->Void, fail: @escaping (Any)->Void){
        Alamofire.request(urlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                result(response.result.value!)
            }else{
                fail(response.error?.localizedDescription ?? "Error");
            }
        }
    }

    
    /// 下载文件
    ///
    /// - Parameters:
    ///   - urlStr: 文件地址
    ///   - method: 请求方式
    ///   - param: 请求参数
    ///   - fileURL: 保存文件路径
    ///   - progress: 下载进度
    ///   - result: 成功返回数据
    ///   - fail: 失败返回数据
    static func ay_downloadFile(_ urlStr: String, _ method: HTTPMethod? = .get, _ param: ayParams? = nil, fileURL: URL, progress: @escaping (Progress)->Void, result: @escaping (Any)->Void, fail: @escaping (Any)->Void) {
        
        //拼接文件保存地址
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            return (fileURL.appendingPathComponent(response.suggestedFilename!), [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(urlStr, method: method!, parameters: param, encoding: URLEncoding.default, headers: nil, to: destination).downloadProgress(queue: DispatchQueue.main, closure: { (progres) in
            progress(progres)
        }).responseData{(response) in
            if response.result.isSuccess {
                result(response.destinationURL!)
            }else{
                fail(response.error?.localizedDescription ?? "Error")
            }
        }
    }
    
    
    /// 文件上传
    ///
    /// 上传文件时注意文件名与 mimeType
    /// - Parameters:
    ///   - urlStr: 上传地址
    ///   - param: 上传参数
    ///   - filesData: 上传数据数组 data 类型
    ///   - progress: 上传进度
    ///   - result: 成功返回数据
    ///   - fail: 失败返回数据
    static func ay_uploadFile(_ urlStr: String, _ param:ayParams? = nil,filesData: [Data], progress:@escaping (Progress)->Void, result: @escaping (Any)->Void, fail: @escaping (Any)->Void) {
        Alamofire.upload(multipartFormData: { (formData) in

            for data:Data in filesData {
                formData.append(data, withName: "file", fileName: "fileName.png", mimeType: "image/png")
            }
            if param != nil {
                for (key , value) in param! {
                    formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: urlStr) { (encodingResult) in
            switch encodingResult{
            case .success(request: let upload,_,_):
                upload.uploadProgress(closure: { (progres) in
                    progress(progres)
                })
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value as? [String : AnyObject]{
                        result(value)
                    }
                })
            case .failure(let error):
                fail(error.localizedDescription)
            }
        }
    }

}
