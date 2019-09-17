//
//  MallListProductItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

///商城的列表的 response
struct SXMallListProductItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXMallListProductItemData
}

// 商城列表的 data数据
struct SXMallListProductItemData: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [SXMallListProductItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

/// 商城列表的具体model
struct SXMallListProductItemModel: Codable {
    let id: TStrInt
    let name: TStrInt
    let image: TStrInt
    let score: TStrInt
    let content: TStrInt
    let stock, weigh: TStrInt
    let status, createtime: TStrInt
    let updatetime, adminID, limit: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, score, content, stock, weigh, status, createtime, updatetime
        case adminID = "admin_id"
        case limit
    }
}

