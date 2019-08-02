//
//  CommentPopMenu.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class CommentPopMenu: UIView {
    //发送评论Block
    var sendBlock: (String) -> Void = { _ in }
    
    //评论
    private var comment:String = "";
    
    //弹窗的背景
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //发送按钮
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送")
        button.setTitleColor(RGBA(255, 74, 92, 1))
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(sendMsgButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    //UITextField的背景
    private lazy var textFieldBack: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "发布评论..."
        textField.font = kFont(14 * iPHONE_AUTORATIO)
        textField.addTarget(self,
                            action: #selector(textFieldValueDidChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    //初始化页面
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI(frame: frame)
        
        textField.becomeFirstResponder()
    }
    
    @objc private func tapGestureRecognizerAction(_ sender:UITapGestureRecognizer) {
        tappedCancel();
    }
    
    //取消
    private func tappedCancel() {
        self.removeFromSuperview();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化界面
    private func setupUI(frame: CGRect) {
        let alertBgView = UIView.init(frame: frame);
        alertBgView.tag = 100;
        alertBgView.backgroundColor = RGBA(0, 0, 0, 0.6);
        alertBgView.isUserInteractionEnabled = true;
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureRecognizerAction(_:)))
        alertBgView.addGestureRecognizer(tap);
        addSubview(alertBgView);
        
        //背景
        addSubview(backView);
        backView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50 * iPHONE_AUTORATIO)
        };
        
        //点击发送按钮
        backView.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(57 * iPHONE_AUTORATIO)
        }
        
        //textField的背景
        backView.addSubview(textFieldBack)
        textFieldBack.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-57 * iPHONE_AUTORATIO)
            make.top.equalTo(8 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-8 * iPHONE_AUTORATIO)
        }
        
        textFieldBack.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(11 * iPHONE_AUTORATIO)
            make.right.equalTo(-11 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func textFieldValueDidChanged(_ textField: UITextField) {
        comment = textField.text ?? ""
    }
    
    @objc private func sendMsgButtonTapped(_ sender: UIButton) {
        sendBlock(comment)
        tappedCancel() //关闭页面
    }

}
