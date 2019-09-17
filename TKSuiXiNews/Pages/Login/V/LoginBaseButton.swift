//
//  SXLoginBaseButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//MARK: - 登录的基类Button
class LoginBaseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化背景
    private func setupUI() {
        backgroundColor = appThemeColor;
        layer.cornerRadius = 22 * iPHONE_AUTORATIO;
        titleLabel?.font = kFont(14 * iPHONE_AUTORATIO);
        setTitleColor(.white, for: .normal);
    }
}
