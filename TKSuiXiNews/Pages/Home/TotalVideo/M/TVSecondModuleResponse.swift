//
//  TVSecondModuleResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - TVSecondModuleResponse
struct TVSecondModuleResponse: Codable {
    let code: Int
    let msg, time: String
    let data: TVSecondModuleDataClass
}

// MARK: - DataClass
struct TVSecondModuleDataClass: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [TVSecondModuleDatum]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct TVSecondModuleDatum: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [JSONAny]
    let video: TStrInt
    let audio, content, nickname, avatar: TStrInt
    let status: String
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
    let type, begintime: TStrInt
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
        case weigh, time, type, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
    }
}
