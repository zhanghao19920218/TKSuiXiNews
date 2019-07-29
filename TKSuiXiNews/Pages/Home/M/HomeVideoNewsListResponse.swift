//
//  HomeVideoNewsListResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let homeVideoNewsListResponse = try? newJSONDecoder().decode(HomeVideoNewsListResponse.self, from: jsonData)

import Foundation

// MARK: - HomeVideoNewsListResponse
struct HomeVideoNewsListResponse: Codable {
    let code: Int
    let msg, time: String
    let data: HomeVideoNewsListResponseDatum
}

// MARK: - DataClass
struct HomeVideoNewsListResponseDatum: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [HomeVideoNewsListModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct HomeVideoNewsListModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [JSONAny]
    let video: TStrInt
    let audio, content, nickname, avatar: TStrInt
    let status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time, begintime: TStrInt
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
        case weigh, time, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
    }
}
