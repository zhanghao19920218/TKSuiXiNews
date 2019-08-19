//
//  ArticleAdminModelResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - ArticleAdminModelResponse
struct ArticleAdminModelResponse: Codable {
    let code: Int
    let msg, time: String
    let data: [ArticleAdminModelDatum]
}

// MARK: - Datum
struct ArticleAdminModelDatum: Codable {
    let id: TStrInt?
    let nickname: TStrInt
    let avatar: TStrInt
    let url: TStrInt
}
