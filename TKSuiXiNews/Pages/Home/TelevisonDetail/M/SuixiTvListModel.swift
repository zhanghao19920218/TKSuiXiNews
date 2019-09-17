//
//  SuixiTvListModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/9/4.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

struct SXTvListModelElement: Codable {
    let date: String
    let list: [SuixiTvListModel]
}

// MARK: - List
struct SuixiTvListModel: Codable {
    let id, articleID: TStrInt
    let date, content: TStrInt
    let now: TStrInt?
    
    enum CodingKeys: String, CodingKey {
        case id
        case articleID = "article_id"
        case date, content, now
    }
}
