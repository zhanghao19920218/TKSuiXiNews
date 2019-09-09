//
//  SystemConfigModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/12.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

// MARK: - SystemConfigModel
struct SystemConfigModel: Codable {
    let code: Int
    let msg, time: String
    let data: SystemConfigModelDataClass
}

// MARK: - DataClass
struct SystemConfigModelDataClass: Codable {
    let iosVersion, iosInfo, iosUpdate, iosDownload: TStrInt
    let androidVersion, androidInfo, androidUpdate, androidDownload: TStrInt
    let defaultSearch, register, qrcode: TStrInt
    let iosUp: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case iosVersion = "ios_version"
        case iosInfo = "ios_info"
        case iosUpdate = "ios_update"
        case iosDownload = "ios_download"
        case androidVersion = "android_version"
        case androidInfo = "android_info"
        case androidUpdate = "android_update"
        case androidDownload = "android_download"
        case defaultSearch = "default_search"
        case register, qrcode
        case iosUp = "ios_up"
    }
}
