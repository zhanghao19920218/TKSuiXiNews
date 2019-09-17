//
//  FavoriteListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

/// 用户点赞的response
struct FavoriteListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: FavoriteListItemData
}

/// 用户点赞的列表data
struct FavoriteListItemData: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [FavoriteListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

/// 用户点赞列表的model
struct FavoriteListItemModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [String]
    let video, audio, content, nickname: TStrInt
    let avatar, status: TStrInt
    let createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
    let type: TStrInt
    var likeStatus, visitNum, commentNum, likeNum: TStrInt
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
