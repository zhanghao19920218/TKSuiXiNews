//
//  HomeMatrixListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - HomeMatrixListItemResponse
struct HomeMatrixListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: [HomeMatrixListItemResponseDatum]
}

// MARK: - HomeMatrixListItemResponseDatum
struct HomeMatrixListItemResponseDatum: Codable {
    let moduleSecond: String
    let data: [HomeMatrixListItemModel]
    
    enum CodingKeys: String, CodingKey {
        case moduleSecond = "module_second"
        case data
    }
}

// MARK: - DatumDatum
struct HomeMatrixListItemModel: Codable {
    let id: TStrInt
    let module, moduleSecond, name: TStrInt?
    let image: TStrInt?
    let video: TStrInt?
    let time: TStrInt?
    let createtime: TStrInt?
    let type: TStrInt?
    let visitNum, likeNum: TStrInt?
    let nickname: TStrInt?
    let avatar: TStrInt?
    
    enum CodingKeys: String, CodingKey {
        case id, module
        case moduleSecond = "module_second"
        case name, image, video, time, createtime, type
        case visitNum = "visit_num"
        case likeNum = "like_num"
        case nickname, avatar
    }
}
