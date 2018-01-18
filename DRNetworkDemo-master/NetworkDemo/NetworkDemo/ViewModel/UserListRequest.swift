//
//  UserRequest.swift
//  NetworkDemo
//
//  Created by dengrui on 16/12/14.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct UserListRequest: Request {
    
    var path: String {
        return "UserInfo/userInfo"
    }
    let method: HTTPMethod = .get
    var parameters: [String: Any] = [:]
    
    typealias Response = UserListModel
    
}


