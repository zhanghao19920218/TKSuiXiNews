//
//  MutiImagesResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/25.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

//MARK: - 多图上传的回复

// MARK: - MutiImagesResponse
struct MutiImagesResponse: Codable {
    let code: Int
    let msg, time: String
    let data: [String]
}
