//
//  UserLoginInfo.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - 用户登陆信息
struct SXLoginInfoResponse: Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: SXLoginInfoCommonModel
}

// MARK: - DataClass
struct SXLoginInfoCommonModel: Codable {
    let userinfo: LoginInfoModel
}

// MARK: - Userinfo
struct LoginInfoModel: Codable {
    let id: TStrInt
    let username, nickname, mobile, avatar: TStrInt
    let score: TStrInt
    let token: TStrInt
    let userID, createtime, expiretime, expiresIn, groupId: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, username, nickname, mobile, avatar, score, token
        case userID = "user_id"
        case createtime, expiretime
        case expiresIn = "expires_in"
        case groupId = "group_id"
    }
}

