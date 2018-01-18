//
//  ViewController.swift
//  AYNetwork_Swift
//
//  Created by Andy on 2017/6/7.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
    
    }
    @IBAction func loadData(_ sender: UIButton) {
        
        
        // post 请求测试
        AYNetworkManager.ay_post("http://localhost:8080/MavenDemo/userApi", ["method":"getAllUsers"], result: { (resultData) in
            print(resultData)
            
            print(Thread.current)

        }) { (failData) in
            print(failData)
        }

        
        /// 文件下载测试
        AYNetworkManager.ay_downloadFile("https://github.com/AndyCuiYTT/AYWebImage/archive/master.zip", fileURL: URL.init(fileURLWithPath: self.ay_getCachePath()), progress: { (progress) in
            print(Thread.current)

            print(progress);
            
            
        }, result: { (resultData) in
            
               print(Thread.current)
            print(resultData);
        }) { (failData) in
            print(failData)
            
        }

        
        /// 文件上传测试
        let img: UIImage = UIImage.init(named: "timg.jpeg")!
        let data: Data = UIImagePNGRepresentation(img)!
        AYNetworkManager.ay_uploadFile("http://localhost:8080/MavenDemo/userApi", ["method":"uploadfile","name":"Angelo","age":"12","id":"1"],filesData: [data,data], progress:{ (progress) in
            print("\(progress.completedUnitCount)-\(progress.totalUnitCount)")
        }, result: { (data) in
            print(data)
        }) { (data) in
            print(data)
        }
        
        
        
        
    }
    
    
    /// 获取图片缓存路径
    ///
    /// - Returns: 图片缓存路径
    private func ay_getCachePath() -> String {
        let fileStr: String = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last?.appending("/imageCache"))!
        let fileManager: FileManager = FileManager.default;
        
        if !fileManager.fileExists(atPath: fileStr) {
            try? fileManager.createDirectory(atPath: fileStr, withIntermediateDirectories: true, attributes: nil);
        }
        return fileStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

