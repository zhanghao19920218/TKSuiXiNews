//
//  AwardDrawResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - AwardDrawResponse
struct AwardDrawResponse: Codable {
    let code: Int
    let msg, time: String
    let data: AwardDrawModel
}

// MARK: - DataClass
struct AwardDrawModel: Codable {
    let id: TStrInt
    let name: TStrInt
    let score, start, end: TStrInt
}
