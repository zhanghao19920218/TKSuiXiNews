//
//  ChangePasswordController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 修改密码的Controller
 */
fileprivate let cellIdentifier = "ChangePasswordCellIdentifier"
fileprivate let codeIdentifier = "ChangePasswordCodeCellIdentifier"

class ChangePasswordController: BaseViewController {
    private var _mobile = ""
    private var _code = ""
    private var _password = ""
    private var _confirmPass = ""
    
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
        tableView.register(ChangePasswordCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(ChangePasswordCodeCell.self, forCellReuseIdentifier: codeIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private lazy var _titles: [String] = {
        return ["手机号","输入验证码", "输入新密码", "输入新密码"]
    }()
    private lazy var _placeholders: [String] = {
        return ["输入手机号","输入验证码", "请输入新密码", "请确认新密码"]
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
            make.height.equalTo(240)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    //MARK: - 点击修改密码按钮
    @objc private func changedPasswordButtonClicked(_ sender: UIButton) {
        print("点击修改密码按钮");
        if !_mobile.isPhoneNumber() {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        
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
        }
        
        //修改密码
        changePasswordSuccess()
    }

}

extension ChangePasswordController {
    private func sendMessageCode() {
        if _mobile.isEmpty || !_mobile.isPhoneNumber() {
            TProgressHUD.show(text: "请输入正确的手机号码")
            return
        }
        
        //MARK: - 发送验证码
        HttpClient.shareInstance.request(target: BAAPI.sendMessageCode(mobile: _mobile, event: "resetpwd"), success: { (json) in
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

extension ChangePasswordController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: codeIdentifier) as! ChangePasswordCodeCell
            cell.title = _titles[indexPath.row]
            cell.placeholder = _placeholders[indexPath.row]
            cell.block = { [weak self] (text) in
                self?._code = text
            }
            cell.sendMegBlock = { [weak self] () in
                self?.sendMessageCode()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as!  ChangePasswordCell
        cell.title = _titles[indexPath.row]
        cell.placeholder = _placeholders[indexPath.row]
        cell.block = { [weak self] (text) in
            if indexPath.row == 0 { self?._mobile = text }
            if indexPath.row == 2 { self?._password = text }
            if indexPath.row == 3 { self?._confirmPass = text }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}