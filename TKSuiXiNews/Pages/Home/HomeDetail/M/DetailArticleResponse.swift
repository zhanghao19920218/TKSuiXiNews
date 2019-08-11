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
    let images: [String]
    let video, audio, content, nickname: TStrInt
    let avatar, status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
    let type: TStrInt
    let vote: Vote?
    let voteOption: [VoteOption]?
    let voteStatus: TStrInt?
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
        case weigh, time, type, vote
        case voteOption = "vote_option"
        case voteStatus = "vote_status"
        case comment, begintime
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

// MARK: - Vote
struct Vote: Codable {
    let id, adminID: TStrInt
    let name, image, content, status: TStrInt
    let createtime, updatetime: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case adminID = "admin_id"
        case name, image, content, status, createtime, updatetime
    }
}

// MARK: - VoteOption
struct VoteOption: Codable {
    let id, voteID: TStrInt
    let name, image: TStrInt
    let count: TStrInt
    let status: TStrInt
    let createtime: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case voteID = "vote_id"
        case name, image, count, status, createtime
    }
}
