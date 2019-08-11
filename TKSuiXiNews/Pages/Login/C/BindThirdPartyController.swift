//
//  BindThirdPartyController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/9.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DefaultsKit
/*
 * 绑定登录页面
 */

class BindThirdPartyController: BaseLoginViewController {
    var thirdId:String = ""
    //手机号码
    private var mobile:String = ""
    private var messageCode:String = ""
    
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
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "绑定注册";
        
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
        
        //注册按钮
        view.addSubview(button);
        button.setTitle("绑 定", for: .normal);
        button.snp.makeConstraints { (make) in
            make.left.equalTo(38 * iPHONE_AUTORATIO);
            make.right.equalTo(-38 * iPHONE_AUTORATIO);
            make.top.equalTo(self.codeTextF.snp_bottom).offset(25 * iPHONE_AUTORATIO);
            make.height.equalTo(44 * iPHONE_AUTORATIO);
        }
    }
    
    
    override func buttonTapped(_ sender: UIButton) {
        print("点击绑定按钮");
        
        if messageCode.isEmpty || mobile.isEmpty {
            TProgressHUD.show(text: "请填写资料完全")
            return
        }
        
        bindingUserInfo()
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
    }
}

extension BindThirdPartyController {
    //MARK: - 发送验证码
    private func sendMessageCode(){
        
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: mobile, event: "bindmobile"), success: { (json) in
            TProgressHUD.show(text: "发送验证码成功")
        }
        )
    }
    
    //注册会员
    private func bindingUserInfo() {
        HttpClient.shareInstance.request(target: BAAPI.bindingMobile(thirdId: thirdId, mobile: mobile, captcha: messageCode), success: { (json) in
            TProgressHUD.show(text: "绑定成功")
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UserSignInModuleResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            let token = userModel.data.userinfo.token.string;
            Defaults.shared.set(token, for: key);
            Defaults.shared.set(userModel.data.userinfo.userID.string, for: userIdKey)
            Defaults.shared.set(userModel.data.userinfo.groupId.int, for: userGroupId)
            //获取七牛云token
            //更新rootVC
            let rootVC = BaseTabBarController.init();
            UIViewController.restoreRootViewController(rootVC);
        }
        )
    }
}
