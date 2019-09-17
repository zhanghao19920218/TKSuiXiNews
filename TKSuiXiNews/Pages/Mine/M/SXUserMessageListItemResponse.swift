//
//  MyMessageListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct SXUserMessageListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: MyMessageListItemData
}

// MARK: - DataClass
struct MyMessageListItemData: Codable {
    let total, perPage, currentPage, lastPage: TStrInt
    let data: [MyMessageListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct MyMessageListItemModel: Codable {
    let id: TStrInt
    let detail: TStrInt
    let status: TStrInt
    let createtime: TStrInt
}

