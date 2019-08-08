//
//  SXLoginViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DefaultsKit

//MARK - 登录页面
// Define a key

fileprivate let fontStyle = kFont(12 * iPHONE_AUTORATIO);
fileprivate let buttonSize = CGSize(width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO);

class SXLoginViewController: BaseLoginViewController {
    //输入手机号码
    private lazy var phoneTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("phone");
        textField.placeholder = "请输入手机号";
        textField.isSuffixHidden = true
        textField.textField.keyboardType = .numberPad
        textField.textField.tag = 1;
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged);
        return textField;
    }()
    
    //输入密码
    private lazy var passwordTextF: SXLoginTextField = {
        let textField = SXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请输入密码";
        textField.textField.tag = 2;
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged);
        return textField;
    }();
    
    //忘记密码
    private lazy var forgetButton: SXForgetBaseButton = {
        let button = SXForgetBaseButton.init(type: .custom);
        button.setTitle("忘 记 密 码", for: .normal);
        button.tag = 4;
        button.addTarget(self,
                         action: #selector(forgetPassSignUpButton(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //立即注册
    private lazy var signUpButton: SXForgetBaseButton = {
        let button = SXForgetBaseButton.init(type: .custom);
        button.setTitle("立 即 注 册", for: .normal);
        button.tag = 5;
        button.addTarget(self,
                         action: #selector(forgetPassSignUpButton(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //第三方登录
    private lazy var thirdTitleL: UILabel = {
        let label = UILabel.init();
        label.textAlignment = .center;
        label.font = fontStyle;
        label.textColor = RGBA(153, 153, 153, 1);
        label.text = "第三方登录"
        return label;
    }();
    
    //QQ登录
    private lazy var qqLoginB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("qq_login"), for: .normal);
        button.tag = 1;
        button.addTarget(self,
                         action: #selector(loginButtonClicked(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //微信登录
    private lazy var wechatLoginB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("wechat_login"), for: .normal);
        button.tag = 2;
        button.addTarget(self,
                         action: #selector(loginButtonClicked(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //sina登录
    private lazy var sinaLoginB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("sina_login"), for: .normal);
        button.tag = 3;
        button.addTarget(self,
                         action: #selector(loginButtonClicked(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //MARK: - 登录数据
    private lazy var model: LoginModel = {
        let model = LoginModel();
        return model;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化标题
        navigationItem.title = "登录"
        
        setupUI()
        
        ThirdPartyLogin.share.delegate = self
    }
    
    //初始化页面
    private func setupUI() {
        view.addSubview(phoneTextF);
        phoneTextF.snp.makeConstraints { (make) in
            make.top.equalTo(190 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        view.addSubview(passwordTextF);
        passwordTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //登录按钮
        view.addSubview(button);
        button.setTitle("登 录", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(self.passwordTextF.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //忘记密码
        view.addSubview(forgetButton);
        forgetButton.snp.makeConstraints { (make) in
            make.left.equalTo(53 * iPHONE_AUTORATIO);
            make.top.equalTo(self.button.snp_bottom).offset(25 * iPHONE_AUTORATIO);
        };
        
        //立即注册
        view.addSubview(signUpButton);
        signUpButton.snp.makeConstraints { (make) in
            make.right.equalTo(-53 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.forgetButton.snp_centerY);
        };
        
        //第三方登录
        view.addSubview(thirdTitleL);
        thirdTitleL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.bottom.equalTo(-110 * iPHONE_AUTORATIO);
        }
        
        //微信登录
        view.addSubview(wechatLoginB);
        wechatLoginB.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.bottom.equalTo(-40 * iPHONE_AUTORATIO);
            make.size.equalTo(buttonSize);
        };
        
        //QQ登录
        view.addSubview(qqLoginB);
        qqLoginB.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.wechatLoginB.snp_centerY);
            make.right.equalTo(self.wechatLoginB.snp_left).offset(-53 * iPHONE_AUTORATIO);
            make.size.equalTo(buttonSize);
        };
        
        //sina登录
        view.addSubview(sinaLoginB);
        sinaLoginB.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.wechatLoginB.snp_centerY);
            make.left.equalTo(self.wechatLoginB.snp_right).offset(53 * iPHONE_AUTORATIO);
            make.size.equalTo(buttonSize);
        };
    }
    
    //登录按钮点击
    override func buttonTapped(_ sender: UIButton) {
        //MARK: - 判断密码账户
        if !model.judgeIsFull() {
            return;
        }
        
        //请求参数登录
        HttpClient.shareInstance.request(target: BAAPI.login(account: model.account, password: model.password), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UserLoginInfo.self, from: json)
            guard let userModel = model else {
                return;
            }
            
            let token = userModel.data.userinfo.token.string;
            Defaults.shared.set(token, for: key);
            Defaults.shared.set(userModel.data.userinfo.userID.string, for: userIdKey);
            self?.requestSevenBeefToken()
            
        }
        )
    }
    
    //MARK: 注册按钮和忘记密码按钮点击
    @objc func forgetPassSignUpButton(_ sender: UIButton) {
        if sender.tag == 4{
            //忘记密码
            let vc = SXForgetPasswordController();
            navigationController?.pushViewController(vc, animated: true);
        } else {
            //立即注册
            let vc = SXSignUpViewController();
            navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @objc func loginButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("QQ登录");
            
            ThirdPartyLogin.share.qqLogin()
            
            break;
        case 2:
            print("微信登录");
            
            ThirdPartyLogin.share.wxLogin()
            
            break;
        case 3:
            print("新浪登录");
            
            ThirdPartyLogin.share.sinaLogin()
            
            break;
        default:
            print("没有登录");
        }
    }
    
    //更新数据
    @objc private func textFieldValueDidChanged(_ sender: UITextField) {
        //更新账户
        if (sender.tag == 1) {
            model.account = sender.text ?? "";
            if model.account.isPhoneNumber() { phoneTextF.isSuffixHidden = false } else { phoneTextF.isSuffixHidden = true }
        } else {
            model.password = sender.text ?? "";
        }
    }

}


extension SXLoginViewController:ThirdPartyLoginDelegate {
    func thirdPartyLoginSuccess(with code: String, platform: String) {
        login(with: platform, code: code)
    }
    
    
    
    //MARK: - 登录回调接口
    private func login(with platform:String, code:String) {
        //请求参数登录
        HttpClient.shareInstance.request(target: BAAPI.thirdPartyLogin(platform: platform, code: code), success: { (json) in
            
        }
        )
    }
    
    //MARK: - 请求七牛云token
    private func requestSevenBeefToken(){
        HttpClient.shareInstance.request(target: BAAPI.qiniuyunToken, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SevenBeefModelResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            Defaults.shared.set(userModel.data.string, for: sevenToken);
            //更新rootVC
            let rootVC = BaseTabBarController.init();
            UIViewController.restoreRootViewController(rootVC);
        })
    }
}
