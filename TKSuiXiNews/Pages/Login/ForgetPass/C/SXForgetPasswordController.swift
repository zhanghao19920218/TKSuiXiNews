//
//  SXForgetPasswordController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//MARK: - 忘记密码按钮

class SXForgetPasswordController: BaseLoginViewController {

    //输入手机号码
    private lazy var phoneTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("phone");
        textField.placeholder = "请输入手机号";
        textField.isSuffixHidden = false;
        return textField;
    }()
    
    //输入验证码
    private lazy var codeTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("safe");
        textField.placeholder = "请输入验证码";
        textField.isShowButton = true;
        return textField;
    }();
    
    //输入验证码
    private lazy var passwordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请输入新密码";
        return textField;
    }();
    
    //输入验证码
    private lazy var confirmPasswordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请确认新密码";
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
        button.setTitle("修 改 密 码", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(self.confirmPasswordTextF.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
    }
    
    
    override func buttonTapped(_ sender: UIButton) {
        print("点击修改密码按钮");
    }
}
