//
//  SinaWeiboModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/7.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct SinaWeiboModel: Codable {
    var uid:String = ""
    var token:String = ""
}

struct QQUserModel: Codable {
    var openId = ""
    var accessToken = ""
    
    enum CodingKeys: String, CodingKey {
        case openId = "openid"
        case accessToken = "access_token"
    }
}
