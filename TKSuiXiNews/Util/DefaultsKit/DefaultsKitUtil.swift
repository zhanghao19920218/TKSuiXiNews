//
//  DefaultsKitUtil.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/19.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import DefaultsKit

class DefaultsKitUtil {
    public static let share = DefaultsKitUtil()
    
    private init() {
        
    }
    
    ///存储手机号码
    /// - Parameters:
    ///   - mobile: 手机号码
    open func storePhoneNum(mobile: String){
        Defaults.shared.set(mobile, for: mobileKey)
    }
    
    ///获取用户手机号码
    open func getMobileNum() -> String {
        return Defaults.shared.get(for: mobileKey) ?? ""
    }
    
    
    ///存储二维码
    /// - Parameters:
    ///   - imageUrl: 图片地址
    open func storeQRAddress(url: String) {
        Defaults.shared.set(url, for: qrCodeKey)
    }
    
    ///获取下载地址二维码
    open func getQRAddress() -> String {
        return Defaults.shared.get(for: qrCodeKey) ?? ""
    }
    
    ///存储用户是不是隐藏
    open func storeServerShow(_ result: Int) {
        Defaults.shared.set(result, for: isShowServerKey)
    }
    
    ///存储用户是不是显示服务的model
    open var isShowServer: Bool {
        get {
            let result = Defaults.shared.get(for: isShowServerKey)
            if result == 1 {
                return false
            } else {
                return true
            }
        }
    }
}
