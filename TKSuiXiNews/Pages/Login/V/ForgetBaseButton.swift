//
//  SXForgetBaseButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ForgetBaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化背景
    private func setupUI() {
        setTitleColor(RGBA(153, 153, 153, 1), for: .normal);
        titleLabel?.font = kFont(12 * iPHONE_AUTORATIO);
    }

}
