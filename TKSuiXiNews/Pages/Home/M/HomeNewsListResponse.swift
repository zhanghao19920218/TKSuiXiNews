//
//  HomeNewsListResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - HomeNewsListResponse
struct HomeNewsListResponse: Codable {
    let code: Int
    let msg, time: String
    let data: HomeNewsListSection
}

// MARK: - HomeNewsListSection
struct HomeNewsListSection: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [HomeNewsListModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - HomeNewsListModel
struct HomeNewsListModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: [String]
    let images: [JSONAny]
    let video, audio, content, nickname: TStrInt
    let avatar, status: TStrInt
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
