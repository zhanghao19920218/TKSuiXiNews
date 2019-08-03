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
    //积分商城商城列表
    case scoreItemList(p: Int)
    //商品详情
    case productDetail(id: Int)
    //积分抽奖奖品列表
    case awardProductItems
    //抽奖
    case awardDraw
    //兑换操作
    case exchangeAward(id: Int)
    //修改会员信息
    case changeMemberInfo(avatar:String,nickname:String)
    //积分明细
    case integralDetail(page: Int)
    //二级模块
    case secondModule(module: String, module_second: String, page: Int)
    //发表评论
    case commentAdd(id: Int, detail:String)
    //发送验证码
    case sendMessageCode(mobile: String, event: String)
    //注册会员
    case registerUserInfo(password:String, captcha: String, mobile:String)
    //点赞
    case addLikeNum(id: Int)
    //取消点赞
    case dislikeComment(id: Int)
    //注销登录
    case logoutLogin
    //顶部banner
    case topBanner(module: String)
    //消息模块
    case messageBlock(page: Int)
    //最近浏览
    case recentlyReview(page: Int)
    //添加收藏
    case addFavorite(id: Int)
    //收藏列表
    case favoriteList(page: Int)
    //兑换列表
    case exchangeProduct(page: Int)
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
            
        case .scoreItemList:
            return K_URL_scoreItemList
            
        case .productDetail:
            return K_URL_productDetail
            
        case .awardProductItems:
            return K_URL_awardProducts
            
        case .awardDraw:
            return K_URL_awardDraw
            
        case .exchangeAward:
            return K_URL_exchangeProduct
            
        case .changeMemberInfo:
            return K_URL_changeMemberInfo
        case .integralDetail:
            return K_URL_IntegralDetail
        case .secondModule:
            return K_URL_contentList
        case .commentAdd:
            return K_URL_commentAdd
        case .sendMessageCode:
            return K_URL_sendMassage
        case .registerUserInfo:
            return K_URL_signIn
        case .addLikeNum:
            return K_URL_addLike
        case .dislikeComment:
            return K_URL_disLike
        case .logoutLogin:
            return K_URL_logOut
        case .topBanner:
            return K_URL_banner
        case .messageBlock:
            return K_URL_messageList
        case .recentlyReview:
            return K_URL_recentlyReview
        case .addFavorite:
            return K_URL_addFavorite
        case .favoriteList:
            return K_URL_favoriteList
        case .exchangeProduct:
            return K_URL_exchangeRecord
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
            }
            
        case let .scoreItemList(p):
            params["p"] = p;
            
        case let .productDetail(id):
            params["id"] = id
            
        case let .exchangeAward(id):
            params["id"] = id
            
        case let .secondModule(module, module_second, page):
            params["module"] = module
            params["module_second"] = module_second
            params["page"] = page
            
        case let .commentAdd(id, detail):
            params["article_id"] = id
            params["detail"] = detail
            
        case let .sendMessageCode(mobile, event):
            params["mobile"] = mobile
            params["event"] = event
            
        case let .registerUserInfo(password, captcha, mobile):
            params["password"] = password
            params["captcha"] = captcha
            params["mobile"] = mobile
            
        case let .addLikeNum(id):
            params["article_id"] = id
        
        case let .dislikeComment(id):
            params["article_id"] = id

        case let .topBanner(module):
            params["module"] = module
            
        case let .messageBlock(page):
            params["p"] = page
            
        case let .recentlyReview(page):
            params["p"] = page
            
        case let .addFavorite(id):
            params["article_id"] = id
            
        case let .favoriteList(page):
            params["p"] = page
            
        case let .exchangeProduct(page):
            params["p"] = page
            
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        print("请求参数: \(params)")
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
}

