//
//  JsonKeyDefine.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import DefaultsKit

//MARK: - K_(里面和接口字段保持一致)
let K_JT_data:String = "data";
let K_JT_list:String = "list";
let K_JT_msg: String = "msg";
let K_JT_code: String = "code";
let K_JT_token: String = "token";
let K_JT_sevenToken: String = "sevenToken"
let K_JT_userId: String = "userId"
let K_JT_groupId: String = "groupId"
let K_JT_placeholder: String = "placeholder"
let K_JT_phoneMobile: String = "mobile"
let K_JT_qrDownload: String = "QrCode"

//MARK: - 登录的appKey
let wechatAppKey = "wx3314443bcadc6e01"
let sinaWeiboAppKey = "3823885346"
let redirectURI = K_URL_Base + "api/third/weibocallback"
let qqAppKey = "101717196"
let key = Key<String>(K_JT_token)
let sevenToken = Key<String>(K_JT_sevenToken)
let userIdKey = Key<String>(K_JT_userId)
let userGroupId = Key<Int>(K_JT_groupId)
let placeholderKey = Key<String>(K_JT_placeholder)
let mobileKey = Key<String>(K_JT_phoneMobile)
let qrCodeKey = Key<String>(K_JT_qrDownload)

