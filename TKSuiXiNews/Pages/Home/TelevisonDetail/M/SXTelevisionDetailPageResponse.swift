//
//  SuiXiTelevisionDetailPageResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
// MARK: - SuiXiTelevisionDetailPageResponse
struct SXTelevisionDetailPageResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXTelevisionDetailPageData
}

// MARK: - DataClass
struct SXTelevisionDetailPageData: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name: TStrInt
    let image: TStrInt
    let images: [String]
    let video: TStrInt
    let audio, content, nickname, avatar: TStrInt
    let status: TStrInt
    let visitNum, commentNum, likeNum, createtime: TStrInt
    let updatetime, voteID, weigh: TStrInt
    let time: TStrInt?
    let type, url: TStrInt
    let zhuanma, shuiyin, voteStatus: TStrInt
    let vote: TStrInt?
    let comment: [String]
    let begintime: TStrInt
    let likeStatus, collectStatus: TStrInt
    let telList: [SXTvListModelElement]
    
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
        case weigh, time, type, url, zhuanma, shuiyin
        case voteStatus = "vote_status"
        case vote, comment, begintime
        case likeStatus = "like_status"
        case collectStatus = "collect_status"
        case telList = "tel_list"
    }
}
