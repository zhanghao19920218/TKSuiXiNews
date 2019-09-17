//
//  ExchangeProductListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

/// 兑换记录的 reponse
struct SXExchangeProductListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXExchangeProductListItemData
}

/// 兑换记录的 model
struct SXExchangeProductListItemData: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [SXExchangeProductListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

/// 兑换记录每一个Item的model
struct SXExchangeProductListItemModel: Codable {
    let id, userID, goodsID: TStrInt
    let name: TStrInt
    let image: TStrInt
    let score: TStrInt
    let status: TStrInt
    let createtime: TStrInt
    let updatetime, adminID: TStrInt
    let registerStatus: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case goodsID = "goods_id"
        case name, image, score, status, createtime, updatetime
        case adminID = "admin_id"
        case registerStatus = "register_status"
    }
}
