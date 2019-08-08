//
//  ForgetPassModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

/*
 * 忘记密码的model
 */

class ForgetPassModel {
    open var mobile: String = "" //手机号
    open var code: String = "" //验证码
    open var password: String = "" //输入新的验证码
    open var confirmPass: String = "" //输入确认的密码
    
    open func isEmpty() -> Bool {
        if mobile.isEmpty || code.isEmpty || password.isEmpty || confirmPass.isEmpty {
            TProgressHUD.show(text: "请完善内容")
            return true
        }
        return false
    }
}
