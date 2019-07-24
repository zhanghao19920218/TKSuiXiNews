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
    //内容模块
    case contentList(module:String, page: Int)
    //会员中心
    case memeberInfo
    //详情
    case articleDetail(id:String)
    //上传文件
    case uploadVideo(data:Data)
    //上传图片
    case uploadImage(data:Data)
}

// 补全【MoyaConfig 3：配置TargetType协议可以一次性处理的参数】中没有处理的参数
extension BAAPI: TargetType {
    
    
    //1. 每个接口的相对路径
    //请求时的绝对路径是   baseURL + path
    var path: String {
        switch self {
        case .login:
            return K_URL_login;
        case .contentList:
            return K_URL_contentList;
        case .memeberInfo:
            return K_URL_mineInfo;
        case .articleDetail:
            return K_URL_articleDetail
        case .uploadVideo, .uploadImage:
            return K_URL_uploadVideo
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
            
        case let .contentList(module, page):
            params["module"] = module;
            params["p"] = page;
            
        case .memeberInfo://不需要传参数的接口走这里
            return .requestPlain
            
        case let .articleDetail(id):
            params["id"] = id;
        case let .uploadVideo(data):
            let videoDataProvider = Moya.MultipartFormData(provider: MultipartFormData.FormDataProvider.data(data), name: "file", fileName: "video.mp4", mimeType: "video/mp4")
            return .uploadMultipart([videoDataProvider]);
            
        case let .uploadImage(data):
            let imageDataProvider = Moya.MultipartFormData(provider: MultipartFormData.FormDataProvider.data(data), name: "file", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([imageDataProvider]);
            
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        print("请求参数: \(params)")
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
}

