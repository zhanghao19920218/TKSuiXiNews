//
//  RotatePanelListItemResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

/// 转盘列表的response
struct SXRotatePanelListItemResponse: Codable {
    let code: Int
    let msg, time: String
    let data: SXRotatePanelListItemDetailData
}

/// 转盘列表的data
struct SXRotatePanelListItemDetailData: Codable {
    let data: [SXRotatePanelListItemModel]
    let num: TStrInt
}

/// 转盘列表的model
struct SXRotatePanelListItemModel: Codable {
    let id: TStrInt
    let name: TStrInt
    let score, ratio, createtime, updatetime: TStrInt
    let adminID: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case id, name, score, ratio, createtime, updatetime
        case adminID = "admin_id"
    }
}
