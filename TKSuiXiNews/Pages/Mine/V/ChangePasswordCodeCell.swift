//
//  ChangePasswordCodeCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ChangePasswordCodeCell: BaseTableViewCell {
    ///发送密码验证码Block
    var block: (String) -> Void = { _ in }

    var sendMegBlock: (CounterButton) -> Void = { _ in}
    
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    var placeholder: String? {
        willSet(newValue) {
            _textField.placeholder = newValue ?? ""
        }
    }
    
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14)
        return label
    }()
    
    private lazy var _textField: UITextField = {
        let textField = UITextField()
        textField.font = kFont(14)
        textField.textAlignment = .right
        textField.addTarget(self,
                            action: #selector(textFiledValueDidChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var sendCodeButton: CounterButton = {
        let button = CounterButton(type: .custom)
        button.setTitleColor(RGBA(255, 74, 92, 1))
        button.titleLabel?.font = kFont(12 * iPHONE_AUTORATIO)
        button.setTitle("发送验证码")
        button.addTarget(self,
                         action: #selector(_sendMessageBtnCode(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        contentView.addSubview(_textField)
        _textField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(90)
            make.right.equalTo(-105)
        }
        
        contentView.addSubview(sendCodeButton)
        sendCodeButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(105)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    @objc private func textFiledValueDidChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        block(text)
    }
    
    @objc private func _sendMessageBtnCode(_ sender: CounterButton) {
        sendMegBlock(sender)
    }
}
