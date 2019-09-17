//
//  ChangePasswordController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let changePasswordIdentifier = "ChangePasswordCellIdentifier"
fileprivate let changeCodeIdentifier = "ChangePasswordCodeCellIdentifier"

///修改密码的Controller
class SXChangePasswordController: SXBaseViewController {
    ///手机号码
    private lazy var _mobile:String = {
        return DefaultsKitUtil.share.getMobileNum
    }()
    ///手机验证码
    private lazy var _code:String = {
        return ""
    }()
    ///手机密码
    private lazy var _password:String = {
        return ""
    }()
    
    ///确认密码
    private lazy var _confirmPass:String = {
        return ""
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = RGBA(255, 74, 92, 1)
        button.setTitle("确 认 修 改")
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(changedPasswordButtonClicked(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SXChangePasswordCell.self, forCellReuseIdentifier: changePasswordIdentifier)
        tableView.register(SXChangePasswordCodeCell.self, forCellReuseIdentifier: changeCodeIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private lazy var _titles: [String] = {
        return ["输入验证码", "输入新密码", "输入新密码"]
    }()
    private lazy var _placeholders: [String] = {
        return ["输入验证码", "请输入新密码", "请确认新密码"]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = RGBA(245, 245, 245, 1)

        // Do any additional setup after loading the view.
        navigationItem.title = "修改密码"
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(1803376)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    //MARK: - 点击修改密码按钮
    @objc private func changedPasswordButtonClicked(_ sender: UIButton) {
        print("点击修改密码按钮")
        
        if _code.isEmpty {
            TProgressHUD.show(text: "请输入验证码")
            return
        }
        
        if _confirmPass.isEmpty  {
            TProgressHUD.show(text: "请输入密码")
            return
        }
        
        if _confirmPass != _password {
            TProgressHUD.show(text: "两次输入密码不一致")
            return
        }
        
        //修改密码
        changePasswordSuccess()
    }

}

extension SXChangePasswordController {
    private func sendMessageCode(_ sender: CounterButton) {
        if _mobile.isEmpty || !_mobile.isPhoneNumber {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        
        //MARK: - 发送验证码
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: _mobile, event: "resetpwd"), success: { (json) in
            ///发送成功进行倒计时
            sender.startCountdown()
            TProgressHUD.show(text: "发送验证码成功")
        }
        )
    }
    
    //修改密码
    private func changePasswordSuccess() {
        HttpClient.shareInstance.request(target: BAAPI.resetPassword(mobile: _mobile, newpassword: _password, captcha: _code), success: { [weak self] (json) in
            self?.navigationController?.popViewController(animated: true)
            TProgressHUD.show(text: "修改密码成功")
            }
        )
    }
}

extension SXChangePasswordController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: changeCodeIdentifier) as! SXChangePasswordCodeCell
            cell.title = _titles[indexPath.row]
            cell.placeholder = _placeholders[indexPath.row]
            cell.block = { [weak self] (text) in
                self?._code = text
            }
            cell.sendMegBlock = { [weak self] (button) in
                self?.sendMessageCode(button)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: changePasswordIdentifier) as!  SXChangePasswordCell
        cell.title = _titles[indexPath.row]
        cell.placeholder = _placeholders[indexPath.row]
        cell.block = { [weak self] (text) in
            if indexPath.row == 1 { self?._password = text }
            if indexPath.row == 2 { self?._confirmPass = text }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
