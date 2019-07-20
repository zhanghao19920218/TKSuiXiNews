//
//  AppDelegate+Other.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

extension AppDelegate
{
    //验证登录
    func verifiedApplicationRootVC () {
        if StaticMethod.share.isUserLogin
        {
            self.window?.rootViewController = BaseTabBarController.init();
        } else
        {
            let rootVC = BANavigationController.init(rootViewController: SXLoginViewController());
            self.window?.rootViewController = rootVC;
        }
    }
}
