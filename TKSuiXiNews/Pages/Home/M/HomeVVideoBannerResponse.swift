//
//  HomeVVideoBannerResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - HomeVVideoBannerResponse
struct HomeVVideoBannerResponse: Codable {
    let code: Int
    let msg, time: String
    let data: [HomeVVideoBannerDatum]
}

// MARK: - Datum
struct HomeVVideoBannerDatum: Codable {
    let id: TStrInt
    let name: TStrInt
    let image: TStrInt
    let content, status: TStrInt
    let createtime, updatetime, adminID, articleID: TStrInt
    let module: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, content, status, createtime, updatetime
        case adminID = "admin_id"
        case articleID = "article_id"
        case module
    }
}
