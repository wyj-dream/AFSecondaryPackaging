//
//  ViewController.swift
//  NetworkDemo
//
//  Created by dengrui on 16/12/14.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取当前时间
        let now = NSDate()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dformatter.string(from: now as Date))")
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        let time = String(timeStamp)
        
        print("当前时间的时间戳：\(time)")

        let client = AlamofireClient()
        let urlRequest = UserListRequest(parameters: ["user_id":"801842","time":time,"token":"DYDK"]
)
        client.send(urlRequest) {
            userlist, error in
            if error != nil {return}
            if let userlist = userlist {
                print(userlist.users!)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

