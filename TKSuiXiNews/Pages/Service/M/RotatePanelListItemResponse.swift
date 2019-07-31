//
//  RotatePanelListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - RotatePanelListItemResponse
struct RotatePanelListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: RotatePanelListItemDetailModel
}

// MARK: - DataClass
struct RotatePanelListItemDetailModel: Codable {
    let data: [RotatePanelListItemModel]
    let num: TStrInt
}

// MARK: - Datum
struct RotatePanelListItemModel: Codable {
    let id: TStrInt
    let name: TStrInt
    let score, ratio, createtime, updatetime: TStrInt
    let adminID: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, name, score, ratio, createtime, updatetime
        case adminID = "admin_id"
    }
}
