//
//  VoteContentDetailModelResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - VoteContentDetailModelResponse
struct SXVoteContentDetailModelResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXVoteContentDetailModelDataModel
}

// MARK: - DataClass
struct SXVoteContentDetailModelDataModel: Codable {
    let id, adminID: TStrInt
    let name, image, content, status: TStrInt
    let createtime, updatetime: TStrInt
    let option: [VoteOption]
    let optionID: TStrInt?
    
    enum CodingKeys: String, CodingKey {
        case id
        case adminID = "admin_id"
        case name, image, content, status, createtime, updatetime, option
        case optionID = "option_id"
    }
}
