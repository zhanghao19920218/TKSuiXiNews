//
//  MemberInfoResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

///会员信息的response
struct SXMemeberInfoResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXMemberInfoModel
}

// MARK: - DataClass
struct SXMemberInfoModel: Codable {
    let id: TStrInt
    let username, nickname, mobile, avatar: TStrInt
    let score: TStrInt
    let token: TStrInt
    let userID, createtime, expiretime, expiresIn, unread: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, username, nickname, mobile, avatar, score, token, unread
        case userID = "user_id"
        case createtime, expiretime
        case expiresIn = "expires_in"
    }
}
