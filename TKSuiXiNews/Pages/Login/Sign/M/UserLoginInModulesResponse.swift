//
//  UserSignInModuleResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - 用户登陆的reponse
struct UserLoginInModulesResponse: Codable {
    let code: Int
    let msg, time: String
    let data: UserLoginInCommonModel
}

// MARK: - 用户登陆的model
struct UserLoginInCommonModel: Codable {
    let userinfo: UserSignInModuleModel
}

// MARK: - 用户登陆的详细model
struct UserSignInModuleModel: Codable {
    let id: TStrInt
    let username, nickname, mobile: TStrInt
    let avatar: TStrInt
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
