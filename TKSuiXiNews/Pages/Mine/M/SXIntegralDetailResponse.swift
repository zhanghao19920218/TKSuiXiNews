//
//  IntegralDetailResponse.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct SXIntegralDetailResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXIntegralDetailData
}

struct SXIntegralDetailData: Codable {
    let currentPage : Int
    let data : [IntegralDetailModel]
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
    }
}


// MARK: - DataClass
struct IntegralDetailModel: Codable {
    let createtime, name, symbol , amount: TStrInt
    enum CodingKeys: String, CodingKey {
        case createtime, name, symbol , amount
    }
}
