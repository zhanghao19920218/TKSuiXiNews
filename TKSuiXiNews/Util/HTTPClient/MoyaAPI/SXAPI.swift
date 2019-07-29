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
    case contentList(module:String, page: Int )
    //内容模块
    case contentSingleList(module:String)
    //会员中心
    case memeberInfo
    //详情
    case articleDetail(id:String)
    //上传文件
    case uploadVideo(data:Data)
    //上传图片
    case uploadImage(data:Data)
    //上传V视频
    case sendVVideoInfo(name:String, video:String, image:String, time:Int)
    //上传多图
    case uploadImages(images:[Image])
    //发布随手拍
    case addsCausualPhotos(name:String, video:String?, images:[String]?, image:String?, time:Int?)
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
        case .contentSingleList:
            return K_URL_contentList;
        case .memeberInfo:
            return K_URL_mineInfo;
        case .articleDetail:
            return K_URL_articleDetail
        case .uploadVideo, .uploadImage:
            return K_URL_uploadVideo
        case .sendVVideoInfo:
            return K_URL_sendVideoDesc
        case .uploadImages:
            return K_URL_multiImages
        case .addsCausualPhotos:
            return K_URL_causualShow
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
            
        case let .contentSingleList(module):
            params["module"] = module;
            
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
            
        case let .sendVVideoInfo(name, video, image, time):
            params["name"] = name;
            params["video"] = video;
            params["image"] = image;
            params["time"] = time;
            
        case let .uploadImages(images):
            var formDataAry = [MultipartFormData]();
            for (index,image) in images.enumerated() {
                //图片转成Data
                let data:Data = image.jpegData(compressionQuality: 0.75) ?? Data.init()
                //根据当前时间设置图片上传时候的名字
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                //别忘记这里给名字加上图片的后缀哦
                dateStr = dateStr.appendingFormat("-%i.jpeg", index)
                let formData = MultipartFormData(provider: .data(data), name: "images[]", fileName: dateStr, mimeType: "image/jpeg")
                formDataAry.append(formData);
                
            }
            return .uploadMultipart(formDataAry);
            
            
        case let .addsCausualPhotos(name, video, images, image, time):
            params["name"] = name;
            if let forceVideo = video {
                params["video"] = forceVideo;
                params["time"] = time ?? "0";
                params["image"] = image ?? "";
            } else {
                //拼装array
                if let arrayImages = images {
                    let array:String = arrayImages.joined(separator: ",");
                    params["images"] = array;
                    print(array);
                }
//                let array = images
//                let data = try? JSONSerialization.data(withJSONObject: images ?? [String](), options: .prettyPrinted);
//                let imagesJson = String(data: data ?? Data.init(), encoding: String.Encoding.unicode);
//                params["images"] = imagesJson ?? "[]";
            }
            
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        print("请求参数: \(params)")
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
}

