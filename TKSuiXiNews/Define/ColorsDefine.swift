//
//  ColorsDefine.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//MARK: -RGBA
func RGBA(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ a:CGFloat) -> UIColor
{
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: a);
}

func RGB(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat) -> UIColor
{
    return RGBA(red, green, blue, 1);
}

//MARK: -App主题颜色
let appThemeColor = RGBA(255, 74, 92, 1);

//MARK: -登录的文本输入框的背景
let loginTextFColor = RGBA(245, 245, 245, 1);
