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
    open var getMobileNum: String {
        get {
            return Defaults.shared.get(for: mobileKey) ?? ""
        }
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
    
    //MARK: - 存储token
    /// - Parameters:
    ///   - token: 存储用户token
    open func storeUserToken(_ token: String) {
        Defaults.shared.set(token, for: key)
    }
    
    
    //MARK: - 获取用户的token
    open var usetToken: String {
        get {
            return Defaults.shared.get(for: key) ?? ""
        }
    }
    
    //MARK: - 存储用户Id
    /// - Parameters:
    ///   - userId: 用户id
    open func storeUserId(id: String) {
        Defaults.shared.set(id, for: userIdKey)
    }
    
    //MARK: - 获取用户id
    open var userId: String {
        get {
            return Defaults.shared.get(for: userIdKey) ?? "0"
        }
    }
    
    //MARK: - 获取用户id
    
    //MARK: - 存储用户团队的id
    /// - Parameters:
    ///   - id: 团队id
    open func storeGroupUserId(_ groupId: Int) {
        Defaults.shared.set(groupId, for: userGroupId)
    }
    
    //MARK: - 获取用户团队的id
    open var groupId: Int {
        get {
            return Defaults.shared.get(for: userGroupId) ?? 0
        }
    }
    
    //MARK: - 保存搜索的占位符
    /// - Parameters:
    ///   - placeholder: 用户占位富豪
    open func storeKeyboardPlaceHolder(_ placeholder:String) {
        Defaults.shared.set(placeholder, for: placeholderKey)
    }
    
    //MARK: 获取用户的占位富豪
    open var placeholder: String {
        get {
            return Defaults.shared.get(for: placeholderKey) ?? "濉溪发布"
        }
    }
}
