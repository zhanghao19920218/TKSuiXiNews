//
//  HomeSpecialColumnResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - ArticleAdminModelResponse
struct HomeSpecialColumnResponse: Codable {
    let code: Int
    let msg, time: String
    let data: HomeSpecialColumnResponseClass
}

// MARK: - DataClass
struct HomeSpecialColumnResponseClass: Codable {
    let total, perPage, currentPage, lastPage: TStrInt
    let data: [HomeSpecialColumnDatum]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct HomeSpecialColumnDatum: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [String]
    let video, audio, content, nickname: TStrInt
    let avatar, status: TStrInt
    let createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time, type, begintime: TStrInt
    let collectStatus: TStrInt
    var likeStatus,visitNum, commentNum, likeNum: TStrInt
    
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
