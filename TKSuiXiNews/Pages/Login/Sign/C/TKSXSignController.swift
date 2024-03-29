//
//  SXSignUpViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//MARK: - 立即注册页面

class TKSXSignController: BaseLoginViewController {
    //手机号码
    private var _mobile:String = ""
    private var _messageCode:String = ""
    private var _password:String = ""
    private var _confirmPassword:String = ""
    
    //获取当前的系统配置
    private var currentConigUrl = ""
    
    //输入手机号码
    private lazy var _phoneTextF: TKSXLoginTextField = {
        let textField = TKSXLoginTextField.init();
        textField.prefix.image = K_ImageName("phone");
        textField.placeholder = "请输入手机号";
        textField.isSuffixHidden = true;
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        textField.textField.tag = 1
        return textField;
    }()
    
    //输入验证码
    private lazy var _codeTextF: TKSXLoginTextField = {
        let textField = TKSXLoginTextField.init();
        textField.prefix.image = K_ImageName("safe");
        textField.placeholder = "请输入验证码";
        textField.isShowButton = true;
        textField.suffixButton.addTarget(self,
                                         action: #selector(sendMssageButton(_:)),
                                         for: .touchUpInside)
        textField.textField.tag = 2
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    //输入验证码
    private lazy var _passwordTextF: TKSXLoginTextField = {
        let textField = TKSXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请输入密码";
        textField.textField.tag = 3
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    //输入验证码
    private lazy var _confirmPasswordTextF: TKSXLoginTextField = {
        let textField = TKSXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请确认密码";
        textField.textField.tag = 4
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    //注册同意的按钮
    private lazy var _licenseView: CommonLicense = {
        let view = CommonLicense()
        return view;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "立即注册";
        
        setupUI()
        
        //请求用户协议
        requestSystemConfigure()
    }
    
    //初始化页面
    private func setupUI() {
        view.addSubview(_phoneTextF);
        _phoneTextF.snp.makeConstraints { (make) in
            make.top.equalTo(180 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        view.addSubview(_codeTextF);
        _codeTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self._phoneTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        view.addSubview(_passwordTextF);
        _passwordTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self._codeTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        view.addSubview(_confirmPasswordTextF);
        _confirmPasswordTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self._passwordTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //注册按钮
        view.addSubview(button);
        button.setTitle("注 册", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(self._confirmPasswordTextF.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //用户协议
        view.addSubview(_licenseView);
        _licenseView.snp.makeConstraints { (make) in
            make.left.equalTo(40 * iPHONE_AUTORATIO);
            make.top.equalTo(self.button.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(20 * iPHONE_AUTORATIO);
            make.width.equalTo(210 * iPHONE_AUTORATIO);
        }
        
        _licenseView.block = { [weak self] () in
            let vc = SXUserRuleController()
            vc.loadUrl = self?.currentConigUrl
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    override func commonLoginBtnTapped(_ sender: UIButton) {
        if !_licenseView.button.isSelected {
            TProgressHUD.show(text: "请同意注册协议")
            return
        }
        
        if _messageCode.isEmpty || _password.isEmpty || _confirmPassword.isEmpty {
            TProgressHUD.show(text: "请完善资料")
            return
        }
        
        if _confirmPassword != _password {
            TProgressHUD.show(text: "两次密码输入不一致")
            return
        }
        
        signInUserInfo()
    }
    
    @objc private func sendMssageButton(_ sender: CounterButton) {
        
        if !_mobile.isPhoneNumber {
            TProgressHUD.show(text: "手机号码错误")
            return
        }
        
        _sendMessageBtnCode(sender)
    }
    
    @objc private func textFieldValueDidChanged(_ sender: UITextField) {
        if sender.tag == 1 {
            _mobile = sender.text ?? ""
            if _mobile.isPhoneNumber { _phoneTextF.isSuffixHidden = false } else { _phoneTextF.isSuffixHidden = true }
        }
        if sender.tag == 2 { _messageCode = sender.text ?? "" }
        if sender.tag == 3 { _password = sender.text ?? "" }
        if sender.tag == 4 { _confirmPassword = sender.text ?? "" }
    }
}

extension TKSXSignController {
    //MARK: - 发送验证码
    private func _sendMessageBtnCode(_ sender: CounterButton){
        
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: _mobile, event: "register"), success: { (json) in
            ///发送验证码
            sender.startCountdown()
            let decoder = JSONDecoder()
            guard let model = try? decoder.decode(BaseModel.self, from: json) else { TProgressHUD.show(text: "发送验证码失败"); return }
            TProgressHUD.show(text: model.msg)
        })
    }
    
    //MARK: - 请求系统参数
    private func requestSystemConfigure() {
        HttpClient.shareInstance.request(target: BAAPI.sysconfigure, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SystemConfigModel.self, from: json)
            if let cofigure = model {
                self?.currentConigUrl = cofigure.data.register.string
            }
        })
    }
    
    //注册会员
    private func signInUserInfo() {
        HttpClient.shareInstance.request(target: BAAPI.registerUserInfo(password: _password, captcha: _messageCode, mobile: _mobile), success: { (json) in
            TProgressHUD.show(text: "注册成功")
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UserLoginInModulesResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            let token = userModel.data.userinfo.token.string
            DefaultsKitUtil.share.storeUserToken(token)
            DefaultsKitUtil.share.storeUserId(id: userModel.data.userinfo.userID.string)
            DefaultsKitUtil.share.storeGroupUserId(userModel.data.userinfo.groupId.int)
            //获取七牛云token
            //更新rootVC
            let rootVC = BaseTabBarController.init();
            UIViewController.restoreRootViewController(rootVC);
        })
    }
}
