//
//  OnlineSendCommentView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///直播发布评论的view

class OnlineSendCommentView: UIView {
    var commentBlock: (String) -> Void = { _ in }
    
    ///评论内容
    private lazy var _comment:String = {
        return ""
    }()

    ///输入框背景的view
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        return view
    }()
    
    ///输入框
    private lazy var _textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "发布评论..."
        textField.font = kFont(14 * iPHONE_AUTORATIO)
        textField.addTarget(self,
                            action: #selector(textFieldValueDidChanged(_:)),
                            for: .editingChanged)
        return textField
    }()

    ///发送按钮
    private lazy var _button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送")
        button.setTitleColor(RGBA(255, 74, 92, 1))
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(sendCommentButtonPressed(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///初始化界面
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(8 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-8 * iPHONE_AUTORATIO)
            make.right.equalTo(-58 * iPHONE_AUTORATIO)
        }
        
        backgroundView.addSubview(_textField)
        _textField.snp.makeConstraints { (make) in
            make.left.equalTo(11 * iPHONE_AUTORATIO)
            make.right.equalTo(-11 * iPHONE_AUTORATIO)
            make.top.bottom.equalToSuperview()
        }
        
        addSubview(_button)
        _button.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(58 * iPHONE_AUTORATIO)
        }
    }
    
    ///更新评论里面的文字
    @objc private func textFieldValueDidChanged(_ textField: UITextField) {
        _comment = textField.text ?? ""
    }
    
    
    ///发送评论
    @objc private func sendCommentButtonPressed(_ sender: UIButton) {
        commentBlock(_comment)
        ///清空评论
        _textField.text = ""
        _textField.resignFirstResponder()
    }
}
