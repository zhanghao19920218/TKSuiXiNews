//
//  ServiceListModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

import Foundation

/// 服务的list model
struct SXServerListModel: Codable {
    let data: [SXServerListModelSectionData]
}

// 服务界面section的model
struct SXServerListModelSectionData: Codable {
    let name: String
    let data: [SXServiceListItemModel]
}

// 服务的liest
struct SXServiceListItemModel: Codable {
    let imagename, title, subTitle, url: String
}

