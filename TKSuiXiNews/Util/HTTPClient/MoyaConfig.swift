//
//  MoyaConfig.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import Moya
import DefaultsKit

#warning("下面的代码需要根据项目进行更改")
// Define a key
/**
 1.状态码 根据自家后台数据更改
 
 - Todo: 根据自己的需要更改
 **/
enum HttpCode : Int {
    case success = 1 //请求成功的状态吗
    case needLogin = 401  // 返回需要登录的错误码
}

/**
 2.为了统一处理错误码和错误信息，在请求回调里会用这个model尝试解析返回值
 - Todo: 根据自家后台更改。
 **/
class BaseModel: Decodable {
    var code: Int
    var msg: String
}

//下面的错误码及错误信息用来在HttpRequest中使用
extension BaseModel {
    var generalStatus: Int {
        return code;
    }
    
    var generalErrmsg: String {
        return msg;
    }
}

/**
 3.配置TargetType协议可以一次性处理的参数
 
 - Todo: 根据自己的需要更改，不能统一处理的移除下面的代码，并在DMAPI中实现
 
 **/
public extension TargetType {
    var baseURL: URL {
        return URL(string: K_URL_Base)!
    }
    
    var headers: [String : String]? {
        let token:String? = Defaults.shared.get(for: key)
        if let toke = token {
            return ["token": toke];
        } else {
            return nil
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}

/**
 4.公共参数
 
 - Todo: 配置公共参数，例如所有接口都需要传token，version，time等，就可以在这里统一处理
 
 - Note: 接口传参时可以覆盖公共参数。下面的代码只需要更改 【private var commonParams: [String: Any]?】
 
 **/
extension URLRequest {
    //TODO：处理公共参数
    private var commonParams: [String: Any]? {
        //所有接口的公共参数添加在这里例如：
        return nil
    }
}

//下面的代码不更改
class RequestHandlingPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutateableRequest = request
        return mutateableRequest.appendCommonParams();
    }
}

//下面的代码不更改
extension URLRequest {
    mutating func appendCommonParams() -> URLRequest {
        let request = try? encoded(parameters: commonParams, parameterEncoding: URLEncoding(destination: .queryString))
        assert(request != nil, "append common params failed, please check common params value")
        return request!
    }
    
    func encoded(parameters: [String: Any]?, parameterEncoding: ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw MoyaError.parameterEncoding(error)
        }
    }
}
