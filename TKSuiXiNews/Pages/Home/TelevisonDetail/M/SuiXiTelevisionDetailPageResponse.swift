//
//  SuiXiTelevisionDetailPageResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - SuiXiTelevisionDetailPageResponse
struct SuiXiTelevisionDetailPageResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SuiXiTelevisionDetailPageClass
}

// MARK: - DataClass
struct SuiXiTelevisionDetailPageClass: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [TStrInt]
    let video: TStrInt
    let audio, content, nickname, avatar: TStrInt
    let status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
    let type: TStrInt
    let comment: [JSONAny]
    let begintime: TStrInt
    let likeStatus, collectStatus: TStrInt
    let telList: [SuiXiTelevisionDetailTelList]
    
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
        case telList = "tel_list"
    }
}

// MARK: - TelList
struct SuiXiTelevisionDetailTelList: Codable {
    let id, articleID: TStrInt
    let date, content: TStrInt
    let adminID, createtime, updatetime: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case articleID = "article_id"
        case date, content
        case adminID = "admin_id"
        case createtime, updatetime
    }
}
