//
//  HomeTVTitleResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - HomeTVTitleResponse
struct HomeTVTitleResponse: Codable {
    let code: Int
    let msg, time: String
    let data: [HomeTVTitleResponseDatum]
}

// MARK: - HomeTVTitleResponseDatum
struct HomeTVTitleResponseDatum: Codable {
    let moduleSecond: String
    let data: [HomeTVTitleModel]
    
    enum CodingKeys: String, CodingKey {
        case moduleSecond = "module_second"
        case data
    }
}

// MARK: - DatumDatum
struct HomeTVTitleModel: Codable {
    let id: TStrInt
    let module: TStrInt
    let moduleSecond: TStrInt
    let name: TStrInt
    let image: TStrInt
    let video: TStrInt
    let time: TStrInt?
    let createtime: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, module
        case moduleSecond = "module_second"
        case name, image, video, time, createtime
    }
}
