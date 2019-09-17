//
//  ShowListResponseModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let showListResponseModel = try? newJSONDecoder().decode(ShowListResponseModel.self, from: jsonData)

import Foundation

///随手拍的response
struct SXShowListResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXShowListData
}

// MARK: - DataClass
struct SXShowListData: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [SXShowListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

/// 随手拍列表的model
struct SXShowListItemModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt?
    let images: [String]
    let video: TStrInt
    let audio, content, nickname, avatar: TStrInt
    let status: TStrInt
    let createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time, type, begintime: TStrInt
    let collectStatus, url: TStrInt
    var likeStatus, visitNum, commentNum, likeNum: TStrInt
    
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
        case weigh, time, type, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
    }
}
