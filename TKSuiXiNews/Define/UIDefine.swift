//
//  UIDefine.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//-------------------------6p related-------------------------
//屏幕  宽  高
let K_SCREEN_WIDTH:  CGFloat = UIScreen.main.bounds.width;
let K_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height;

//判断是否是iPhone X
let iPhoneX:Bool = (K_SCREEN_HEIGHT == 812.0) ? true : false;

//iPhone XR or XS Max
let iPhoneXR:Bool = (K_SCREEN_WIDTH == 414.0 && K_SCREEN_HEIGHT == 896.0);
let iPhoneMax:Bool = (K_SCREEN_WIDTH >= 375.0 && K_SCREEN_HEIGHT >= 812.0);

//状态栏高度
let STATUS_BAR_HEIGHT:CGFloat = (iPhoneX || iPhoneXR || iPhoneMax ? 44.0 : 20.0);

let STATUS_BAR_OFFSET:CGFloat = (iPhoneX || iPhoneXR || iPhoneMax ? 24.0 : 0);
//导航栏高度
let NAVIGATION_BAR_HEIGHT:CGFloat = (iPhoneX || iPhoneXR || iPhoneMax ? 88.0 : 64.0);
//tabBar高度
let TAB_BAR_HEIGHT:CGFloat = (iPhoneX || iPhoneXR || iPhoneMax ? 83.0 : 49.0);
//home indicator
let HOME_INDICATOR_HEIGHT:CGFloat = (iPhoneX || iPhoneXR || iPhoneMax ? 34.0 : 0.0);

//适配UI
let iPHONE_AUTORATIO:CGFloat = ((K_SCREEN_WIDTH == 414.0) ? 1.1 : ((K_SCREEN_WIDTH == 375.0) ? 1.0 : ((K_SCREEN_WIDTH == 320.0) ? 0.86 : 1.3)));

//--------------------接口返回字符串判空-----------------
let PLACE_HOLDER_IMAGE = "placeHolderImage";

func K_ImageName(_ name:String) -> UIImage? {
    return UIImage.init(named: name);
}

func kFont(_ value:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: value);
}

func kBoldFont(_ value:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: value);
}
