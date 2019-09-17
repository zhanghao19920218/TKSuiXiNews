//
//  AwardDrawResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

/// 现场获奖的response
struct SXAwardDrawResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXAwardDrawModel
}

/// 现场获奖的model
struct SXAwardDrawModel: Codable {
    let id: TStrInt
    let name: TStrInt
    let score, start, end: TStrInt
}
