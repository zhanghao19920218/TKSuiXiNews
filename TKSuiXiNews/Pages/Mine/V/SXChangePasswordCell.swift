//
//  ChangePasswordCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///修改密码的Cell
class SXChangePasswordCell: BaseTableViewCell {
    ///点击修改密码的Block
    var block: (String) -> Void = { _ in }
    
    ///标题
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    ///占位placeholder
    var placeholder: String? {
        willSet(newValue) {
            _textField.placeholder = newValue ?? ""
        }
    }

    ///用户标题
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
            make.left.equalTo(90 * iPHONE_AUTORATIO)
            make.right.equalTo(-15)
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
}
