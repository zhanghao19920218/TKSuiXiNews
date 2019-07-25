//
//  UIButton+Extension.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

extension UIButton {
    //MARK: - 设置背景
    open func setImage(_ imagename: String) {
        setImage(K_ImageName(imagename), for: .normal);
    }
    
    //MARK: - 设置标题
    open func setTitle(_ title: String) {
        setTitle(title, for: .normal);
    }
    
    //MARK: - 设置标题颜色
    open func setTitleColor(_ titleColor: UIColor) {
        setTitleColor(titleColor, for: .normal)
    }
}
