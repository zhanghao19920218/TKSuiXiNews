//
//  ThirdPartyModelResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/9.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - ThirdPartyModelResponse
struct ThirdPartyModelResponse: Codable {
    let code: Int
    let msg, time: String
    let data: ThirdPartyModelDataClass
}

// MARK: - DataClass
struct ThirdPartyModelDataClass: Codable {
    let thirdID: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case thirdID = "third_id"
    }
}

