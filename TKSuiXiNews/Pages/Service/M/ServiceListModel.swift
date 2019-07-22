//
//  ServiceListModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

import Foundation

// MARK: - ServerListModel
struct ServerListModel: Codable {
    let data: [ServerListModelSectionItem]
}

// MARK: - ServerListModelDatum
struct ServerListModelSectionItem: Codable {
    let name: String
    let data: [ServiceListItemModel]
}

// MARK: - DatumDatum
struct ServiceListItemModel: Codable {
    let imagename, title, subTitle: String
}

