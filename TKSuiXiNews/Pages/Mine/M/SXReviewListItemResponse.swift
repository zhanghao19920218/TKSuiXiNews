//
//  ReviewListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

/// 用户浏览记录的response
struct SXReviewListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXReviewListItemData
}

/// 用户浏览记录的数据Data
struct SXReviewListItemData: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [SXReviewListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

/// 用户浏览记录的model
struct SXReviewListItemModel: Codable {
    let id, userID, adminID: TStrInt
    let module: TStrInt
    let moduleSecond: TStrInt
    let name: TStrInt
    let image: TStrInt
    let images: [String]
    let video: TStrInt
    let audio: TStrInt
    let content, nickname, avatar: TStrInt
    let status: TStrInt
    let createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt
    let type: TStrInt
    var likeStatus, commentNum, likeNum, visitNum: TStrInt
    let url: TStrInt?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case adminID = "admin_id"
        case module
        case moduleSecond = "module_second"
        case name, image, images, video, audio, content, nickname, avatar, status, url
        case visitNum = "visit_num"
        case commentNum = "comment_num"
        case likeNum = "like_num"
        case createtime, updatetime
        case voteID = "vote_id"
        case weigh, time, type
        case likeStatus = "like_status"
    }
}
