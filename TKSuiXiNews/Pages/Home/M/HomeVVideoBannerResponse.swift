//
//  HomeVVideoBannerResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - HomeVVideoBannerResponse
struct HomeVVideoBannerResponse: Codable {
    let code: Int
    let msg, time: String
    let data: [HomeVVideoBannerDatum]
}

// MARK: - Datum
struct HomeVVideoBannerDatum: Codable {
    let id: TStrInt
    let name: TStrInt
    let image: TStrInt
    let content, status: TStrInt
    let createtime, updatetime, adminID, articleID: TStrInt
    let module, url: TStrInt
    let articleInfo: BannerArticleInfoModel?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, content, status, createtime, updatetime
        case adminID = "admin_id"
        case articleID = "article_id"
        case module, url
        case articleInfo = "article_info"
    }
}

struct BannerArticleInfoModel: Codable {
    let id, userID, adminID: TStrInt
    let module, moduleSecond, name, image: TStrInt
    let images: [String]?
    let video, audio, content, nickname: TStrInt?
    let avatar, status: TStrInt?
    let visitNum, commentNum, likeNum, createtime: TStrInt?
    let updatetime, voteID, weigh: TStrInt?
    let time, type, url: TStrInt?
    let zhuanma, shuiyin: TStrInt?
    
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
    }
}
