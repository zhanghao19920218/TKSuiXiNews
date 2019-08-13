//
//  HomeChannelListModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/13.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - HomeChannelListModel
struct HomeChannelListModel: Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: [String]
}
