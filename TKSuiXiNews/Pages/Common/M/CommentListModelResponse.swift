//
//  CommentListModelResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/14.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - CommentListModel
struct CommentListModelResponse: Codable {
    let code: Int
    let msg, time: String
    let data: CommentListModel
}

// MARK: - DataClass
struct CommentListModel: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [SXCommentListModelDatum]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct SXCommentListModelDatum: Codable {
    let id, userID, articleID: TStrInt
    let detail, nickname: TStrInt
    let avatar: TStrInt
    let status, createtime: TStrInt
    let updatetime, adminID, adminStatus: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case articleID = "article_id"
        case detail, nickname, avatar, status, createtime, updatetime
        case adminID = "admin_id"
        case adminStatus = "admin_status"
    }
}
