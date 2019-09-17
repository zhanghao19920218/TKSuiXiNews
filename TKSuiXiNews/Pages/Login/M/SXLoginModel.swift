//
//  LoginModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXLoginModel: Codable {
    
    open var account: String = ""; //账户
    open var password: String = ""; //密码
    open var code: String = ""; //二维码

    func judgeIsFull() -> Bool {
        if account.isEmpty {
            TProgressHUD.show(text: "请填写账户");
            return false;
        }
        
        if password.isEmpty {
            TProgressHUD.show(text: "请填写密码");
            return false;
        }
        
        return true;
    }
    
    func judgeCodeFull() -> Bool {
        if account.isEmpty {
            TProgressHUD.show(text: "请填写账户");
            return false;
        }
        
        if code.isEmpty {
            TProgressHUD.show(text: "请填写验证码");
            return false;
        }
        
        return true;
    }
}
