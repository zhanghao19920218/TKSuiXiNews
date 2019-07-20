//
//  HttpClientSample.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import Moya

class HttpClient
{
    public static let shareInstance = HttpClient();
    
    private init() {
        
    }
    
    public func request<T: TargetType>(target:T, success: @escaping((Data) -> Void) ) {
        //请求成功进行再次刷新数据
        HttpRequest.loadData(target: target,
                             success: success) { (errorCode, errorMessage) in
                                
                                TProgressHUD.show(text: errorMessage);
        }
    
    }
}
