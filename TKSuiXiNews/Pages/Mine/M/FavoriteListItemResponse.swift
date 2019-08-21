//
//  FavoriteListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - FavoriteListItemResponse
struct FavoriteListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: FavoriteListItemClass
}

// MARK: - DataClass
struct FavoriteListItemClass: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [FavoriteListItemDatum]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct FavoriteListItemDatum: Codable {
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
        case weigh, time, type
        case likeStatus = "like_status"
    }
}
