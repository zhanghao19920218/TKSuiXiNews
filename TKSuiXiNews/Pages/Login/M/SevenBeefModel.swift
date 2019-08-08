//
//  SevenBeefModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - 七牛云的model
struct SevenBeefModelResponse: Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: TStrInt
}
