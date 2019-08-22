//
//  SXForgetPasswordController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DefaultsKit

//MARK: - 忘记密码

class SXForgetPasswordController: BaseLoginViewController {
    //创建修改密码model
    private lazy var _model: ForgetPassModel = {
        let model = ForgetPassModel()
        return model
    }()

    //输入手机号码
    private lazy var phoneTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("phone");
        textField.placeholder = "请输入手机号";
        textField.isSuffixHidden = true
        textField.textField.tag = 1
        textField.textField.keyboardType = .numberPad
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }()
    
    //输入验证码
    private lazy var codeTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("safe");
        textField.placeholder = "请输入验证码";
        textField.isShowButton = true;
        textField.textField.tag = 2
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        textField.suffixButton.addTarget(self,
                                         action: #selector(getMessageCodeButtonPressed(_:)),
                                         for: .touchUpInside)
        return textField;
    }();
    
    //输入验证码
    private lazy var passwordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请输入新密码";
        textField.textField.tag = 3
        textField.textField.isSecureTextEntry = true
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    //输入验证码
    private lazy var confirmPasswordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请确认新密码";
        textField.textField.tag = 4
        textField.textField.isSecureTextEntry = true
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "忘记密码";
        
        setupUI();
    }
    
    //初始化页面
    private func setupUI() {
        view.addSubview(phoneTextF);
        phoneTextF.snp.makeConstraints { (make) in
            make.top.equalTo(180 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        view.addSubview(codeTextF);
        codeTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        }
        
        view.addSubview(passwordTextF);
        passwordTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self.codeTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        view.addSubview(confirmPasswordTextF);
        confirmPasswordTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //注册按钮
        view.addSubview(button);
        button.setTitle("修 改 密 码", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(self.confirmPasswordTextF.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
    }
    
    override func popViewControllerBtnPressed() {
        //先确定是不是退出页面
        AlertPopMenu.show(title: "修改密码", detail: "是否放弃修改密码", confirmTitle: "确定", doubleTitle: "取消", confrimBlock: {
            super.popViewControllerBtnPressed(); //点击确定返回
        }) {
            
        }
    }
    
    override func buttonTapped(_ sender: UIButton) {
        print("点击修改密码按钮");
        if !_model.mobile.isPhoneNumber() {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        
        if _model.isEmpty() {
            return
        }
        
        if _model.confirmPass != _model.password {
            TProgressHUD.show(text: "两次输入密码不一致")
        }
        
        //修改密码
        changePasswordSuccess()
    }
    
    //MARK: - 修改当前页面的手机号码, 验证码, 新密码, 确认新的密码
    @objc private func textFieldValueDidChanged(_ sender: UITextField) {
        if sender.tag == 1 { //手机号码
            _model.mobile = sender.text ?? ""
            if _model.mobile.isPhoneNumber() { phoneTextF.isSuffixHidden = false } else { phoneTextF.isSuffixHidden = true }
        }
        if sender.tag == 2 { //验证码
            _model.code = sender.text ?? ""
        }
        if sender.tag == 3 { //密码
            _model.password = sender.text ?? ""
        }
        if sender.tag == 4 { //确认密码
            _model.confirmPass = sender.text ?? ""
            if _model.password == _model.confirmPass { confirmPasswordTextF.isSuffixHidden = false } else { confirmPasswordTextF.isSuffixHidden = true }
        }
    }
    
    //MARK: - 点击获取验证码
    @objc private func getMessageCodeButtonPressed(_ sender: CounterButton) {
        if !_model.mobile.isPhoneNumber() {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        //发送验证码
        sendMessageCode(sender)
    }
}


extension SXForgetPasswordController {
    //MARK: - 发送验证码
    private func sendMessageCode(_ sender: CounterButton){
        
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: _model.mobile, event: "resetpwd"), success: { (json) in
            sender.startCountdown()
            TProgressHUD.show(text: "发送验证码成功")
        })
    }
    
    //修改密码
    private func changePasswordSuccess() {
        HttpClient.shareInstance.request(target: BAAPI.resetPassword(mobile: _model.mobile, newpassword: _model.password, captcha: _model.code), success: { [weak self] (json) in
            self?.navigationController?.popViewController(animated: true)
            TProgressHUD.show(text: "修改密码成功")
        }
        )
    }
}
