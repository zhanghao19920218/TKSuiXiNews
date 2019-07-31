//
//  MallListProductItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct MallListProductItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: MallListProductItemDetail
}

// MARK: - DataClass
struct MallListProductItemDetail: Codable {
    let total, perPage, currentPage, lastPage: Int
    let data: [MallListProductItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct MallListProductItemModel: Codable {
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

