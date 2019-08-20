//
//  SXSignUpViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DefaultsKit

//MARK: - 立即注册页面

class SXSignUpViewController: BaseLoginViewController {
    //手机号码
    private var mobile:String = ""
    private var messageCode:String = ""
    private var password:String = ""
    private var confirmPassword:String = ""
    
    //获取当前的系统配置
    private var currentConigUrl = ""
    
    //输入手机号码
    private lazy var phoneTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
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
    private lazy var codeTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
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
    private lazy var passwordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请输入密码";
        textField.textField.tag = 3
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    //输入验证码
    private lazy var confirmPasswordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请确认密码";
        textField.textField.tag = 4
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }();
    
    //注册同意的按钮
    private lazy var licenseView: CommonLicense = {
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
        };
        
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
        button.setTitle("注 册", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(self.confirmPasswordTextF.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //用户协议
        view.addSubview(licenseView);
        licenseView.snp.makeConstraints { (make) in
            make.left.equalTo(40 * iPHONE_AUTORATIO);
            make.top.equalTo(self.button.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(20 * iPHONE_AUTORATIO);
            make.width.equalTo(210 * iPHONE_AUTORATIO);
        }
        
        licenseView.block = { [weak self] () in
            let vc = TKRuleController()
            vc.loadUrl = self?.currentConigUrl
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    override func buttonTapped(_ sender: UIButton) {
        print("点击注册按钮");
        if !licenseView.button.isSelected {
            TProgressHUD.show(text: "请同意注册协议")
            return
        }
        
        if messageCode.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            TProgressHUD.show(text: "请完善资料")
            return
        }
        
        if confirmPassword != password {
            TProgressHUD.show(text: "两次密码输入不一致")
            return
        }
        
        signInUserInfo()
    }
    
    @objc private func sendMssageButton(_ sender: UIButton) {
        
        if !(mobile.isPhoneNumber()) {
            TProgressHUD.show(text: "手机号码错误")
            return
        }
        
        sendMessageCode()
    }
    
    @objc private func textFieldValueDidChanged(_ sender: UITextField) {
        if sender.tag == 1 {
            mobile = sender.text ?? ""
            if mobile.isPhoneNumber() { phoneTextF.isSuffixHidden = false } else { phoneTextF.isSuffixHidden = true }
        }
        if sender.tag == 2 { messageCode = sender.text ?? "" }
        if sender.tag == 3 { password = sender.text ?? "" }
        if sender.tag == 4 { confirmPassword = sender.text ?? "" }
    }
}

extension SXSignUpViewController {
    //MARK: - 发送验证码
    private func sendMessageCode(){
        
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: mobile, event: "register"), success: { (json) in
            TProgressHUD.show(text: "发送验证码成功")
        }
        )
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
        HttpClient.shareInstance.request(target: BAAPI.registerUserInfo(password: password, captcha: messageCode, mobile: mobile), success: { (json) in
            TProgressHUD.show(text: "注册成功")
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UserSignInModuleResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            let token = userModel.data.userinfo.token.string;
            Defaults.shared.set(token, for: key);
            Defaults.shared.set(userModel.data.userinfo.userID.string, for: userIdKey);
            Defaults.shared.set(userModel.data.userinfo.groupId.int, for: userGroupId)
            //获取七牛云token
            //更新rootVC
            let rootVC = BaseTabBarController.init();
            UIViewController.restoreRootViewController(rootVC);
        }
        )
    }
}
