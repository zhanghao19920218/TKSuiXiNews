//
//  StaticMethod.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import DefaultsKit

class StaticMethod
{
    //监测用户是不是登录
    private let key = Key<String>(K_JT_token);
    
    static let share = StaticMethod.init();
    
    private init () {}
    
    //判断用户是不是登录
    var isUserLogin: Bool {
        get {
            if Defaults.shared.has(key) {
                return true;
            } else {
                return false;
            }
        }
    }
}
