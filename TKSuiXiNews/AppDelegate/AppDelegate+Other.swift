//
//  AppDelegate+Other.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

extension AppDelegate
{
    //验证登录
    func verifiedApplicationRootVC () {
        if StaticMethod.share.isUserLogin
        {
            self.window?.rootViewController = BaseTabBarController.init();
        } else
        {
            let rootVC = BANavigationController.init(rootViewController: SXLoginViewController());
            self.window?.rootViewController = rootVC;
        }
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return ThirdPartyLogin.share.handleOpenUrl(url, "")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let vc = UIViewController.current() //判断当前是QQ登录页面还是分享页面
        let urlKey:String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        if vc is SXLoginViewController {
            return ThirdPartyLogin.share.handleOpenUrl(url, urlKey)
        }
        if urlKey.contains("com.tencent.mqq") { //QQ分享
            return  QQShareInstance.share.handleOpenUrl(url, urlKey)
        }
        return ThirdPartyLogin.share.handleOpenUrl(url, urlKey)
        
    }
    
    // 新浪微博的H5网页登录回调需要实现这个方法
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // 这里的URL Schemes是配置在 info -> URL types中, 添加的新浪微博的URL schemes
        // 例如: 你的新浪微博的AppKey为: 123456789, 那么这个值就是: wb123456789
        if url.scheme == "wb3823885346" {
            // 新浪微博 的回调
            return ThirdPartyLogin.share.handle(url)
        }
        
        return true
    }
}
