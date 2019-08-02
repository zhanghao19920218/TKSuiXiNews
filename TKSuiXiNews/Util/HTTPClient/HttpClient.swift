//
//  HttpClientSample.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import Moya
import DefaultsKit

private let key = Key<String>(K_JT_token);

class HttpClient
{
    public static let shareInstance = HttpClient();
    
    private init() {
        
    }
    
    public func request<T: TargetType>(target:T, success: @escaping((Data) -> Void), failure: (()->Void)? = nil ) {
        //请求成功进行再次刷新数据
        HttpRequest.loadData(target: target,
                             success: success) { (errorCode, errorMessage) in
                                failure;
                                TProgressHUD.show(text: errorMessage);
        }
    
    }
    
    //MARK: 是不是需要显示登陆的警告, 更换显示的路由器
    func userSignOutByTokenOutData()
    {
        let navigationVC = BANavigationController.init(rootViewController:SXLoginViewController());
        Defaults.shared.clear(key);
        UIViewController.restoreRootViewController(navigationVC);
    }
    
}
