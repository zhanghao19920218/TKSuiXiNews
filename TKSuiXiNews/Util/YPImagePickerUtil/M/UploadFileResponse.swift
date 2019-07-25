//
//  UploadFileResponse.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/25.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - UploadFileResponse
struct UploadFileResponse: Codable {
    let code: TStrInt
    let msg, time: TStrInt
    let data: UploadFileModel
}

// MARK: - DataClass
struct UploadFileModel: Codable {
    let url: TStrInt
}

