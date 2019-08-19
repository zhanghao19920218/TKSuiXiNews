//
//  SwitchLoginTypeView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/19.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///切换密码登录或者验证码登录
enum LoginType: Int {
    case password = 1 //密码登录
    case code  //验证码登录
}

fileprivate let selectedColor = RGBA(255, 74, 92, 1)
fileprivate let normalColor = RGBA(245, 245, 245, 1)

class SwitchLoginTypeView: UIView {
    ///切换的Block
    var swapBlock: (LoginType) -> Void = { _ in }
    
    ///默认密码登录
    private var selectedType: LoginType = .password
    
    //密码登录
    private lazy var passwordLoginB: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("密码登录")
        button.titleLabel?.font = kFont(12 * iPHONE_AUTORATIO)
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = selectedColor
        button.tag = 1
        button.isSelected = true
        button.addTarget(self,
                         action: #selector(swapLoginTypeButton(_:)),
                         for: .touchUpInside)
        button.layer.cornerRadius = 17 * iPHONE_AUTORATIO
        return button
    }()
    
    //验证码登录
    private lazy var codeLoginB: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("验证码登录")
        button.titleLabel?.font = kFont(12 * iPHONE_AUTORATIO)
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = normalColor
        button.tag = 2
        button.addTarget(self,
                         action: #selector(swapLoginTypeButton(_:)),
                         for: .touchUpInside)
        button.layer.cornerRadius = 17 * iPHONE_AUTORATIO
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///创建界面
    private func _setupUI() {
        backgroundColor = RGBA(245, 245, 245, 1)
        
        addSubview(passwordLoginB)
        passwordLoginB.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(150 * iPHONE_AUTORATIO)
        }
        
        addSubview(codeLoginB)
        codeLoginB.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(150 * iPHONE_AUTORATIO)
        }
    }
    
    ///MARK: - 点击切换登录类型
    @objc private func swapLoginTypeButton(_ sender: UIButton) {
        if sender.tag == 1 { //密码登录
            selectedType = .password
            codeLoginB.isSelected = false
            codeLoginB.backgroundColor = normalColor
            sender.backgroundColor = selectedColor
            passwordLoginB.isSelected = true
        } else { //验证码登录
            selectedType = .code
            passwordLoginB.isSelected = false
            passwordLoginB.backgroundColor = normalColor
            sender.backgroundColor = selectedColor
            codeLoginB.isSelected = true
        }
        swapBlock(selectedType)
    }
}
