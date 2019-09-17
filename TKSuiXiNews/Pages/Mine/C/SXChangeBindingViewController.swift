//
//  ChangeBindingViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXChangeBindingViewController: SXBaseViewController {
    ///用户手机号码
    private lazy var _mobile:String = {
        return ""
    }()
    
    ///验证码
    private lazy var _code:String = {
       return ""
    }()
    
    private lazy var _backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var _mobileTitleL: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.text = "手机号"
        return label
    }()
    
    private lazy var _textField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.font = kFont(14 * iPHONE_AUTORATIO)
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.tag = 1
        textField.addTarget(self,
                            action: #selector(textFieldValueDidChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var _codeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.text = "验证码"
        return label
    }()
    
    private lazy var _sendCodeButton: CounterButton = {
        let button = CounterButton(type: .custom)
        button.autoStartCounddown = false
        button.setTitleColor(RGBA(255, 74, 92, 1))
        button.titleLabel?.font = kFont(12 * iPHONE_AUTORATIO)
        button.setTitle("发送验证码")
        button.addTarget(self,
                         action: #selector(_sendMessageBtnCode(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var _line1: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(238, 238, 238, 1)
        return view
    }()
    
    private lazy var _messageTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入验证码"
        textField.keyboardType = .numberPad
        textField.tag = 2
        textField.addTarget(self,
                            action: #selector(textFieldValueDidChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var _confirmBindButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = RGBA(255, 74, 92, 1)
        button.setTitle("确 认 绑 定")
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(confirmBinding(_:)),
                         for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "更换绑定"
        
        setupUI()
    }
    
    
    func setupUI()  {
        view.backgroundColor = RGBA(245, 245, 245, 1)
        
        view.addSubview(_backgroundView)
        _backgroundView.snp.makeConstraints { (make) in
            make.left.top.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.height.equalTo(106 * iPHONE_AUTORATIO)
        }
        
        _backgroundView.addSubview(_mobileTitleL)
        _mobileTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.top.equalTo(20 * iPHONE_AUTORATIO)
        }
        
        _backgroundView.addSubview(_textField)
        _textField.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_mobileTitleL.snp_centerY)
        }
        
        _backgroundView.addSubview(_line1)
        _line1.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(53 * iPHONE_AUTORATIO)
            make.height.equalTo(1)
        }
        
        _backgroundView.addSubview(_codeTitleLabel)
        _codeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(73 * iPHONE_AUTORATIO)
            make.left.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        _backgroundView.addSubview(_sendCodeButton)
        _sendCodeButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 90 * iPHONE_AUTORATIO, height: 52 * iPHONE_AUTORATIO))
        }
        
        _backgroundView.addSubview(_messageTextField)
        _messageTextField.snp.makeConstraints { (make) in
            make.right.equalTo(_sendCodeButton.snp_left)
            make.centerY.equalTo(_codeTitleLabel.snp_centerY)
        }
        
        view.addSubview(_confirmBindButton)
        _confirmBindButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(49 * iPHONE_AUTORATIO)
        }
    }
    
    @objc private func textFieldValueDidChanged(_ sender: UITextField) {
        if sender.tag == 1 {
            _mobile = sender.text ?? ""
        } else {
            _code = sender.text ?? ""
        }
    }
    
    @objc private func _sendMessageBtnCode(_ sender: CounterButton) {
        if _mobile.isEmpty || !_mobile.isPhoneNumber {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        
        //MARK: - 发送验证码
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: _mobile, event: "changemobile"), success: { (json) in
            ///发送成功进行倒计时
            sender.startCountdown()
            TProgressHUD.show(text: "发送验证码成功")
        }
        )
    }

    @objc private func confirmBinding(_ sender: UIButton) {
        if _mobile.isEmpty || !_mobile.isPhoneNumber {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        
        if _code.isEmpty {
            TProgressHUD.show(text: "请输入验证码")
            return
        }
        
        //MARK: - 发送验证码
        HttpClient.shareInstance.request(target: BAAPI.changeMobile(mobile: _mobile, code: _code), success: { [weak self] (json) in
            //修改手机号码
            self?.navigationController?.popToRootViewController(animated: true)
            TProgressHUD.show(text: "确定绑定成功")
        }
        )
    }
}