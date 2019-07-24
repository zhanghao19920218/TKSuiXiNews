//
//  DetailArticleResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct DetailArticleResponse: Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: DetailArticleModel
}

// MARK: - DataClass
struct DetailArticleModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [String]?
    let video: TStrInt
    let audio: TStrInt
    let content: JSONNull?
    let nickname, avatar, status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt
    let comment: [DetailInfoComment]?
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
        case weigh, time, comment, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
    }
}

// MARK: - Comment
struct DetailInfoComment: Codable {
    let id, userID, articleID: TStrInt
    let detail, nickname, avatar, status: TStrInt
    let createtime, updatetime: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case articleID = "article_id"
        case detail, nickname, avatar, status, createtime, updatetime
    }
}
