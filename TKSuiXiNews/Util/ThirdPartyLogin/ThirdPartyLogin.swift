//
//  ThirdPartyLogin.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/7.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

protocol ThirdPartyLoginDelegate {
    func thirdPartyLoginSuccess(with code:String, platform:String)
}

class ThirdPartyLogin:NSObject {
    var delegate: ThirdPartyLoginDelegate?
    
    private lazy var _tencentOAuth: TencentOAuth = {
        return TencentOAuth.init(appId: qqAppKey, andDelegate: self)
    }()
    
    static let share = ThirdPartyLogin()
    
    override init() {
        super.init()
    }
    
    //注册
    open func register() {
        WXApi.registerApp(wechatAppKey)
        WeiboSDK.registerApp(sinaWeiboAppKey)
        WeiboSDK.enableDebugMode(true) //支持debug
    }
    
    //处理打开wechat
    open func handleOpenUrl(_ url:URL, _ urlKey: String) -> Bool{
        if urlKey == "com.sina.weibo" {
            // 新浪微博 的回调
            return WeiboSDK.handleOpen(url, delegate: self)
        } else if urlKey == "com.tencent.mqq" {
            return TencentOAuth.handleOpen(url)
        }
        return WXApi.handleOpen(url, delegate: self)
    }
    
    /// 新浪微博的回调 写在func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    ///
    /// - Parameter url: url
    /// - Returns: return value
    open func handle(_ url: URL) -> Bool {
        // response
        return WeiboSDK.handleOpen(url, delegate: self)
    }
    
    //掉起微信登录
    open func wxLogin() {
        if !WXApi.isWXAppInstalled() {
            TProgressHUD.show(text: "请先安装微信")
            return
        }
        
        if !WXApi.isWXAppSupport() {
            TProgressHUD.show(text: "微信不支持第三方登录")
            return
        }
        //构造SendAuthReq结构体
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "authState"//可随便写
        WXApi.send(req)
    }
    
    //吊起微博登录
    open func sinaLogin() {
        let request = WBAuthorizeRequest()
        request.redirectURI = redirectURI
        request.scope = "all"
        
        WeiboSDK.send(request)
    }
    
    //QQ登录
    open func qqLogin() {
        let _permissions = ["get_user_info","get_simple_userinfo", "add_t"]
        _tencentOAuth.authorize(_permissions) //设置应用需要用户授权的API列表。 (建议如果授权过多的话，可能会造成用户不愿意授权。这里最好只授权应用需要用户赋予的授权。)
    }
    
    //MARK: - 分享微博
    func shareWebToSina(title:String, url:String) {
        let authReq = WBAuthorizeRequest()
        authReq.redirectURI = redirectURI
        authReq.scope = "all"
        
        let message = WBMessageObject()
        message.text = title
        
        let web = WBWebpageObject()
        //        WBBaseMediaObject
        web.objectID = url
        web.title = title
        web.description = ""
        //        web.scheme = "" // 点击多媒体内容时唤起第三方应用的指定页面
        let thumbImg = K_ImageName(PLACE_HOLDER_IMAGE)
        // 不能超过32k
        web.thumbnailData = thumbImg!.pngData()!
        
        web.webpageUrl = url
        
        message.mediaObject = web
        
        let req: WBSendMessageToWeiboRequest = WBSendMessageToWeiboRequest.request(withMessage: message, authInfo: authReq, access_token: nil) as! WBSendMessageToWeiboRequest
        req.userInfo = ["info": "分享的新闻链接"] // 自定义的请求信息字典， 会在响应中原样返回
        req.shouldOpenWeiboAppInstallPageIfNotInstalled = false // 当未安装客户端时是否显示下载页
        
        let re = WeiboSDK.send(req)
        
        print("------\(re)")
    }
    
    //MARK: - 分享微信好友
    func shareWechatFriend(title:String, url:String) {
        let message = WXMediaMessage()
        message.title = title
        message.description = title
        message.setThumbImage(K_ImageName(PLACE_HOLDER_IMAGE)!)
        
        let obj = WXWebpageObject()
        obj.webpageUrl = url
        message.mediaObject = obj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req)
    }
    
    //MARK: - 分享微信朋友圈
    func shareWechatTimeline(title:String, url:String) {
        let message = WXMediaMessage()
        message.title = title
        message.description = title
        message.setThumbImage(K_ImageName(PLACE_HOLDER_IMAGE)!)
        
        let obj = WXWebpageObject()
        obj.webpageUrl = url
        message.mediaObject = obj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        
        req.scene = Int32(WXSceneTimeline.rawValue)
        
        WXApi.send(req)
    }
}

extension ThirdPartyLogin: WXApiDelegate {
    func onResp(_ resp: BaseResp) {
        //微信登录回调
        if resp is SendAuthResp {
            let authResp = resp as! SendAuthResp
            switch authResp.errCode {
            case 0:
                TProgressHUD.show(text: "登录成功")
                let code = authResp.code ?? ""
                if let delegate = delegate  {
                    delegate.thirdPartyLoginSuccess(with: code, platform: "wechat")
                }
            default:
                TProgressHUD.show(text: "登录失败")
            }
        }
    }
}

extension ThirdPartyLogin: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        guard let res = response as? WBAuthorizeResponse else { return  }
        
        guard let uid = res.userID else { return  }
        guard let accessToken = res.accessToken else { return }
        
        var model = SinaWeiboModel()
        model.token = accessToken
        model.uid = uid
        
        let jsonData = try! JSONEncoder().encode(model)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        
        if let delegate = delegate  {
            delegate.thirdPartyLoginSuccess(with: jsonString, platform: "weibo")
        }
    }
    
    
}

extension ThirdPartyLogin: TencentSessionDelegate {
    
    func tencentDidLogin() {
        if _tencentOAuth.accessToken.count > 0 {
            //获取用户信息
            _tencentOAuth.getUserInfo()
            print("登录的token:\(String(describing: _tencentOAuth.accessToken))")
            print("登录的token:\(String(describing: _tencentOAuth.openId))")
            
            var model = QQUserModel()
            model.accessToken = _tencentOAuth.accessToken
            model.openId = _tencentOAuth.openId
            
            let jsonData = try! JSONEncoder().encode(model)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            if let delegate = delegate  {
                delegate.thirdPartyLoginSuccess(with: jsonString, platform: "qq")
            }
            TProgressHUD.show(text: "登录成功")
        } else {
            TProgressHUD.show(text: "登录不成功 没有获取token")
        }
    }
    
    
    func tencentDidNotLogin(_ cancelled: Bool) {
//        <#code#>
    }
    
    func tencentDidNotNetWork() {
//        <#code#>
    }
    // 获取用户信息
    func getUserInfoResponse(_ response: APIResponse!) {
        if let _ = response, (response.retCode == Int32(URLREQUEST_SUCCEED.rawValue)) {
            let userInfo = response.jsonResponse
            let nickName = userInfo?["nickname"] as? String
            if let name = nickName {
                print(name)
            }
            
        }
    }
}

class QQShareInstance:NSObject {
    private lazy var _tencentOAuth: TencentOAuth = {
        return TencentOAuth.init(appId: qqAppKey, andDelegate: nil)
    }()
    
    static let share = QQShareInstance()
    
    private override init() {
        super.init()
    }
    
    
    //分享QQ
    open func shareQQ(title:String, url:String) {
        //先授权
        _tencentOAuth = TencentOAuth.init(appId: qqAppKey, andDelegate: nil)
        
        if !QQApiInterface.isQQInstalled() {
            TProgressHUD.show(text: "请先安装QQ")
            return
        }
        
        if !QQApiInterface.isQQSupportApi() {
            TProgressHUD.show(text: "您手机QQ版本太低,暂不支持分享")
            return
        }
        
        
        let url = URL(string: url)

        let obj = QQApiNewsObject(url: url!, title: title, description: "", previewImageData: K_ImageName(PLACE_HOLDER_IMAGE)?.jpegData(compressionQuality: 0.75), targetContentType: QQApiURLTargetTypeNews)

        let req = SendMessageToQQReq(content: obj)
        
        //分享到QQ
        QQApiInterface.send(req)
    }
    
    
}

extension QQShareInstance: QQApiInterfaceDelegate {
    //处理打开wechat
    open func handleOpenUrl(_ url:URL, _ urlKey: String) -> Bool{
        return QQApiInterface.handleOpen(url, delegate: self)
    }
    
    func onResp(_ resp: QQBaseResp!) {
        print("QQ回调")
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        print("QQ回调")
    }
    
    func onReq(_ req: QQBaseReq!) {
        print("QQ回调")
    }
}
