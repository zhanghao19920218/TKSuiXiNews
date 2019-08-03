//
//  MyMessageListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct MyMessageListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: MyMessageListItemClass
}

// MARK: - DataClass
struct MyMessageListItemClass: Codable {
    let total, perPage, currentPage, lastPage: TStrInt
    let data: [MyMessageListItemDatum]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

// MARK: - Datum
struct MyMessageListItemDatum: Codable {
    let id: TStrInt
    let detail: TStrInt
    let status: TStrInt
    let createtime: TStrInt
}

