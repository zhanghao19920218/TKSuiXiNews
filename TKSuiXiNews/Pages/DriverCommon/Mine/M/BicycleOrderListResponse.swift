//
//  BicycleOrderListResponse.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - BicycleOrderListResponse
struct BicycleOrderListResponse: Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: BicycleOrderListModelClass
}

// MARK: - Datum
struct BicycleOrderListModelClass: Codable {
    let currentPage, lastPage, total, perPage: Int
    let data: [BicycleOrderListModel]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case total
        case perPage = "per_page"
        case data
    }
}

// MARK: - Datum
struct BicycleOrderListModel: Codable {
    let createtime, time, money: TStrInt
}
