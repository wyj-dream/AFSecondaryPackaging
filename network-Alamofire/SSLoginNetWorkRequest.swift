//
//  SSNetWorkText.swift
//  SmartStore_Swift
//
//  Created by maowo－001 on 2017/3/1.
//  Copyright © 2017年 maowo－001. All rights reserved.
//

import UIKit
import ObjectMapper

class SSLoginNetWorkRequest: NSObject {
    
    class func requestCityList(method:RequestMethod,params:NSMutableDictionary,success:@escaping ([SSCityModel])->(),failure:@escaping (Error)->()) -> Void {
        
        SSBaseNetWork.shareNetWorkBase.isNeedAccessToken = false
        SSBaseNetWork.shareNetWorkBase .RequestParams(url:"", method: method, params: params, success: { (respones) in
            print(respones)
            
            if respones is NSNumber {
                
                print("no success or no Data")
            
            } else {
                
                //解析数据
                //let cityList = Mapper<SSCityModel>().mapArray(JSONArray: respones as! [[String : Any]])
                
                //success(cityList!)
                
            }
            
        }) { (error) in
            print(error)
        }
        
    }
}
