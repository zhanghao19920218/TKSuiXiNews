//
//  IntegralDetailResponse.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct IntegralDetailResponse: Codable {
    let code: Int
    let msg, time: String
    let data: IntegralDetailResponseMap
}

struct IntegralDetailResponseMap: Codable {
    let currentPage : Int
//    let total, perPage, lastPage: Int
    let data : [IntegralDetailModel]
    enum CodingKeys: String, CodingKey {
//        case total
//        case perPage = "per_page"
        case currentPage = "current_page"
//        case lastPage = "last_page"
        case data
    }
}


// MARK: - DataClass
struct IntegralDetailModel: Codable {
    let createtime, name, symbol , amount: TStrInt
//    let admin_id, id, score , type , updatetime ,user_id: TStrInt
    enum CodingKeys: String, CodingKey {
        case createtime, name, symbol , amount
//        case admin_id, id, score , type , updatetime ,user_id
    }
}
