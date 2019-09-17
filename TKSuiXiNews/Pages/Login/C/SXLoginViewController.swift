//
//  SXLoginViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//MARK - 登录页面
// Define a key

fileprivate let fontStyle = kFont(12 * iPHONE_AUTORATIO);
fileprivate let buttonSize = CGSize(width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO);

class SXLoginViewController: BaseLoginViewController {
    ///判断登录的类型
    var loginType: LoginType = .password
    
    
    //输入手机号码
    private lazy var _phoneTextF: TKSXLoginTextField = {
        let textField = TKSXLoginTextField.init();
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
    private lazy var _passwordTextF: TKSXLoginTextField = {
        let textField = TKSXLoginTextField.init();
        textField.prefix.image = K_ImageName("psw");
        textField.placeholder = "请输入密码";
        textField.textField.tag = 2;
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged);
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
        textField.textField.tag = 3
        textField.isHidden = true
        textField.textField.addTarget(self,
                                      action: #selector(textFieldValueDidChanged(_:)),
                                      for: .editingChanged)
        return textField;
    }()
    
    //忘记密码
    private lazy var _forgetButton: ForgetBaseButton = {
        let button = ForgetBaseButton.init(type: .custom);
        button.setTitle("忘 记 密 码", for: .normal)
        button.tag = 4
        button.addTarget(self,
                         action: #selector(forgetPassSignUpButton(_:)),
                         for: .touchUpInside);
        return button
    }();
    
    ///立即注册
    private lazy var _signUpButton: ForgetBaseButton = {
        let button = ForgetBaseButton.init(type: .custom);
        button.setTitle("立 即 注 册", for: .normal);
        button.tag = 5;
        button.addTarget(self,
                         action: #selector(forgetPassSignUpButton(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    ///第三方登录
    private lazy var _thirdTitleL: UILabel = {
        let label = UILabel.init();
        label.textAlignment = .center;
        label.font = fontStyle;
        label.textColor = RGBA(153, 153, 153, 1);
        label.text = "第三方登录"
        return label;
    }();
    
    ///QQ登录
    private lazy var _qqLoginB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("qq_login"), for: .normal);
        button.tag = 1;
        button.addTarget(self,
                         action: #selector(loginButtonClicked(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    ///微信登录
    private lazy var _wechatLoginB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("wechat_login"), for: .normal);
        button.tag = 2;
        button.addTarget(self,
                         action: #selector(loginButtonClicked(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    ///sina登录
    private lazy var _sinaLoginB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("sina_login"), for: .normal);
        button.tag = 3;
        button.addTarget(self,
                         action: #selector(loginButtonClicked(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //MARK: - 登录数据
    private lazy var _model: SXLoginModel = {
        let model = SXLoginModel()
        return model;
    }();
    
    ///登录的验证码
    private lazy var _swapLoginView: SwitchLoginTypeView = {
        let view = SwitchLoginTypeView()
        view.layer.cornerRadius = 17 * iPHONE_AUTORATIO
        view.swapBlock = { [weak self] (type) in
            self?.loginType = type
            if type == .password { //如果密码登录
                self?._passwordTextF.isHidden = false
                self?._codeTextF.isHidden = true
            } else { //验证码登录
                self?._passwordTextF.isHidden = true
                self?._codeTextF.isHidden = false
            }
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //请求系统参数
        requestSystemConfigure()
        
        //初始化标题
        navigationItem.title = "登录"
        
        setupUI()
        
        ThirdPartyLogin.share.delegate = self

    }
    
    //初始化页面
    private func setupUI() {
        view.addSubview(_swapLoginView)
        _swapLoginView.snp.makeConstraints { (make) in
            make.top.equalTo(164 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 300 * iPHONE_AUTORATIO, height: 34 * iPHONE_AUTORATIO))
        }
        
        
        view.addSubview(_phoneTextF);
        _phoneTextF.snp.makeConstraints { (make) in
            make.top.equalTo(223 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };

        view.addSubview(_passwordTextF);
        _passwordTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self._phoneTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        }
        
        view.addSubview(_codeTextF)
        _codeTextF.snp.makeConstraints { (make) in
            make.top.equalTo(self._phoneTextF.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        }
        
        //登录按钮
        view.addSubview(button);
        button.setTitle("登 录", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(351 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        };
        
        //忘记密码
        view.addSubview(_forgetButton);
        _forgetButton.snp.makeConstraints { (make) in
            make.left.equalTo(53 * iPHONE_AUTORATIO);
            make.top.equalTo(self.button.snp_bottom).offset(25 * iPHONE_AUTORATIO);
        };
        
        //立即注册
        view.addSubview(_signUpButton);
        _signUpButton.snp.makeConstraints { (make) in
            make.right.equalTo(-53 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self._forgetButton.snp_centerY);
        };
        
        //第三方登录
        view.addSubview(_thirdTitleL);
        _thirdTitleL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.bottom.equalTo(-110 * iPHONE_AUTORATIO);
        }
        
        //微信登录
        view.addSubview(_wechatLoginB);
        _wechatLoginB.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.bottom.equalTo(-40 * iPHONE_AUTORATIO);
            make.size.equalTo(buttonSize);
        };
        
        //QQ登录
        view.addSubview(_qqLoginB);
        _qqLoginB.snp.makeConstraints { (make) in
            make.centerY.equalTo(self._wechatLoginB.snp_centerY);
            make.right.equalTo(self._wechatLoginB.snp_left).offset(-53 * iPHONE_AUTORATIO);
            make.size.equalTo(buttonSize);
        };
        
        //sina登录
        view.addSubview(_sinaLoginB);
        _sinaLoginB.snp.makeConstraints { (make) in
            make.centerY.equalTo(self._wechatLoginB.snp_centerY);
            make.left.equalTo(self._wechatLoginB.snp_right).offset(53 * iPHONE_AUTORATIO);
            make.size.equalTo(buttonSize);
        };
    }
    
    //登录按钮点击
    override func commonLoginBtnTapped(_ sender: UIButton) {
        //关闭键盘
        _phoneTextF.textField.resignFirstResponder()
        _passwordTextF.textField.resignFirstResponder()
        _codeTextF.textField.resignFirstResponder()
        
        if loginType == .password { //账户密码登录
            loginInWithAccoutPassword()
        } else { //验证码账户登录
            loginWithRegisterCaptcha()
        }
    }
    
    //MARK: 注册按钮和忘记密码按钮点击
    @objc func forgetPassSignUpButton(_ sender: UIButton) {
        if sender.tag == 4{
            //忘记密码
            let vc = SXForgetPasswordController();
            navigationController?.pushViewController(vc, animated: true);
        } else {
            //立即注册
            let vc = TKSXSignController();
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
            _model.account = sender.text ?? "";
            if _model.account.isPhoneNumber { _phoneTextF.isSuffixHidden = false } else { _phoneTextF.isSuffixHidden = true }
        } else if sender.tag == 2 {
            _model.password = sender.text ?? "";
        } else { //验证码
            _model.code = sender.text ?? ""
        }
    }
    
    @objc private func sendMssageButton(_ sender: CounterButton) {
        
        if !_model.account.isPhoneNumber {
            TProgressHUD.show(text: "手机号码错误")
            return
        }
        
        sendMessageCode(sender)
    }

}


extension SXLoginViewController:ThirdPartyLoginDelegate {
    func shareInformationSuccess() {
        
    }
    
    func thirdPartyLoginSuccess(with code: String, platform: String) {
        login(with: platform, code: code)
    }
    
    //MARK: - 发送验证码
    private func sendMessageCode(_ sender: CounterButton){
        
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: _model.account, event: "mobilelogin"), success: { (json) in
            ///发送验证码
            sender.startCountdown()
            TProgressHUD.show(text: "发送验证码成功")
        }
        )
    }
    
    //MARK: - 登录回调接口
    private func login(with platform:String, code:String) {
        //请求参数登录
        HttpClient.shareInstance.request(target: BAAPI.thirdPartyLogin(platform: platform, code: code), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let baseModel = try? decoder.decode(BaseModel.self, from: json)
            guard let model = baseModel else {
                return
            }
            if model.code == 1 {
                let userModels = try? decoder.decode(SXLoginInfoResponse.self, from: json)
                guard let userModel = userModels else {
                    return;
                }
                
                let token = userModel.data.userinfo.token.string
                DefaultsKitUtil.share.storeUserToken(token)
                DefaultsKitUtil.share.storeUserId(id: userModel.data.userinfo.userID.string)
                DefaultsKitUtil.share.storeGroupUserId(userModel.data.userinfo.groupId.int)
                DefaultsKitUtil.share.storePhoneNum(mobile: userModel.data.userinfo.mobile.string)
                //更新rootVC
                let rootVC = BaseTabBarController.init();
                UIViewController.restoreRootViewController(rootVC)
            }
            
            if model.code == 5 {
                let thirdModel = try? decoder.decode(ThirdPartyModelResponse.self, from: json)
                guard let thirdmodel = thirdModel else {
                    return
                }
                
                let vc = BindThirdPartyController()
                vc.thirdId = thirdmodel.data.thirdID.string
                self?.navigationController?.pushViewController(vc, animated: true)
            }}
        )
    }
}


extension SXLoginViewController {
    ///账户密码登录
    private func loginInWithAccoutPassword() {
        //MARK: - 判断密码账户
        if !_model.judgeIsFull() {
            return;
        }
        
        //请求参数登录
        HttpClient.shareInstance.request(target: BAAPI.login(account: _model.account, password: _model.password), success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXLoginInfoResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            
            let token = userModel.data.userinfo.token.string;
            DefaultsKitUtil.share.storeUserToken(token)
            DefaultsKitUtil.share.storeUserId(id: userModel.data.userinfo.userID.string)
            DefaultsKitUtil.share.storeGroupUserId(userModel.data.userinfo.groupId.int)
            DefaultsKitUtil.share.storePhoneNum(mobile: userModel.data.userinfo.mobile.string)
            
            //判断是不是需要显示服务页面
            if DefaultsKitUtil.share.isShowServer {
                //正常VC
                let rootVC = BaseTabBarController.init();
                UIViewController.restoreRootViewController(rootVC)
            } else {
                //出行VC
                let rootVC = BicycleTabBarController()
                UIViewController.restoreRootViewController(rootVC)
            }
        })
    }
    
    
    ///账户验证码登录
    private func loginWithRegisterCaptcha(){
        //MARK: - 判断密码账户
        if !_model.judgeCodeFull() {
            return;
        }
        
        //请求参数登录
        HttpClient.shareInstance.request(target: BAAPI.mobileCaptcha(mobile: _model.account, captcha: _model.code), success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXLoginInfoResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            
            let token = userModel.data.userinfo.token.string;
            DefaultsKitUtil.share.storeUserToken(token)
            DefaultsKitUtil.share.storeUserId(id: userModel.data.userinfo.userID.string)
            DefaultsKitUtil.share.storeGroupUserId(userModel.data.userinfo.groupId.int)
            DefaultsKitUtil.share.storePhoneNum(mobile: userModel.data.userinfo.mobile.string)
            
            //判断是不是需要显示服务页面
            if DefaultsKitUtil.share.isShowServer {
                //正常VC
                let rootVC = BaseTabBarController.init();
                UIViewController.restoreRootViewController(rootVC)
            } else {
                //出行VC
                let rootVC = BicycleTabBarController()
                UIViewController.restoreRootViewController(rootVC)
            }
        })
    }
    
    
    //MARK: - 请求系统参数
    private func requestSystemConfigure() {
        HttpClient.shareInstance.request(target: BAAPI.sysconfigure, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SystemConfigModel.self, from: json)
            if let cofigure = model {
                DefaultsKitUtil.share.storeKeyboardPlaceHolder(cofigure.data.defaultSearch.string)
                DefaultsKitUtil.share.storeQRAddress(url: cofigure.data.qrcode.string)
                DefaultsKitUtil.share.storeServerShow(cofigure.data.iosUp.int)
            }
        })
    }
}
