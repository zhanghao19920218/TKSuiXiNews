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

// MARK: - ShowListResponseModel
struct ShowListResponseModel: Codable {
    let code: Int
    let msg, time: String
    let data: ShowListDataModel
}

// MARK: - DataClass
struct ShowListDataModel: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [ShowListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct ShowListItemModel: Codable {
    let id, userID, adminID: TStrInt
    let module: TStrInt
    let moduleSecond, name: TStrInt
    let image: TStrInt?
    let images: [String]
    let video: TStrInt
    let audio: TStrInt
    let content: JSONNull?
    let nickname: TStrInt
    let avatar: TStrInt
    let status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
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
        case weigh, time, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
    }
}
