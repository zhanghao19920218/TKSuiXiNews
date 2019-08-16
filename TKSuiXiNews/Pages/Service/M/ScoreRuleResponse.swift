//
//  ScoreRuleResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

///积分规则的Model

class ScoreRuleResponse:Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: ScoreRuleModel
}

// MARK: - DataClass
struct ScoreRuleModel: Codable {
    let name, nickname, time, content: TStrInt
}
