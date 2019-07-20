//
//  SXAPI.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import Moya

enum  BAAPI {
    //用户登录
    case login(account:String, password: String)
}

// 补全【MoyaConfig 3：配置TargetType协议可以一次性处理的参数】中没有处理的参数
extension BAAPI: TargetType {
    
    
    //1. 每个接口的相对路径
    //请求时的绝对路径是   baseURL + path
    var path: String {
        switch self {
        case .login:
            return K_URL_login;
        }
        
    }
    
    
    //2. 每个接口要使用的请求方式
    var method: Moya.Method {
        return .post;
    }
    
    //3. Task是一个枚举值，根据后台需要的数据，选择不同的http task。
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case let .login(account, password):
            params["account"] = account;
            params["password"] = password;
            
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        print("请求参数: \(params)")
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
}

