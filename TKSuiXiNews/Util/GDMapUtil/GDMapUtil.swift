//
//  GDMapUtil.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import AMapFoundationKit

///高德地图的SDK
class GDMapUtil {
    //MARK: - 初始化高德SDK
    public static func initApiKey(){
        AMapServices.shared()?.apiKey = "f87580a07484381af3ac37acdd94349c"
    }
    
}
