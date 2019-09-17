//
//  SuiXiBocastListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - SuiXiBocastListItemResponse
struct SXBocastListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXBocastListItemModel
}

// MARK: - DataClass
struct SXBocastListItemModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [TStrInt]?
    let video, audio, content, nickname: TStrInt
    let avatar, status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
    let type: TStrInt
    let comment: [SuiXiBocastListItemComment]?
    let begintime: TStrInt
    let likeStatus, collectStatus: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case adminID = "admin_id"
        case module
        case moduleSecond = "module_second"
        case name, image, images, video, audio, content, nickname, avatar, status
        case visitNum = "visit_num"
        case commentNum = "comment_num"
        case likeNum = "like_num"
        case createtime, updatetime
        case voteID = "vote_id"
        case weigh, time, type, comment, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
    }
}

// MARK: - Comment
struct SuiXiBocastListItemComment: Codable {
    let id, userID, articleID: TStrInt
    let detail, nickname: TStrInt
    let avatar: TStrInt
    let status, createtime: TStrInt
    let updatetime: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case articleID = "article_id"
        case detail, nickname, avatar, status, createtime, updatetime
    }
}
