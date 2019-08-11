//
//  MineSettingViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let str : String = "MineSettingTableViewCell"

class MineSettingViewController: BaseViewController {
    
    private var leftitems = [String]()
    
    private lazy var bottomBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = RGB(255, 74, 92)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = kFont(16)
        btn.setTitle("退出登录", for: .normal)
        btn.addTarget(self, action: #selector(self.clickExitAppAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = RGB(244, 245, 247)
        tableView.register(MineSettingTableViewCell.self, forCellReuseIdentifier: str)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统设置"
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        leftitems = ["修改密码"]
        createView()
    }
    
    func createView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.top.right.equalToSuperview()
            ConstraintMaker.bottom.equalTo(-50)
        }
        
        self.view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.bottom.right.equalToSuperview()
            ConstraintMaker.height.equalTo(50)
        }
        
        let topBgView = UIView()
        topBgView.frame = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: 20)
        tableView.tableHeaderView = topBgView
        
        let topLayerView = UIView()
        topLayerView.backgroundColor = .white
        topLayerView.layer.cornerRadius = 10
        topLayerView.layer.masksToBounds = true
        topBgView.addSubview(topLayerView)
        topLayerView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(15)
            ConstraintMaker.top.equalTo(15)
            ConstraintMaker.right.equalTo(-15)
            ConstraintMaker.height.equalTo(20)
        }
        
        let bottomBgView = UIView()
        bottomBgView.frame = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: 20)
        tableView.tableFooterView = bottomBgView
        
        let bottomLayerView = UIView()
        bottomLayerView.backgroundColor = .white
        bottomLayerView.layer.cornerRadius = 10
        bottomLayerView.layer.masksToBounds = true
        bottomBgView.addSubview(bottomLayerView)
        bottomLayerView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(15)
            ConstraintMaker.top.equalTo(-10)
            ConstraintMaker.right.equalTo(-15)
            ConstraintMaker.height.equalTo(20)
        }
        
    }
    
    @objc func clickExitAppAction(){
        let alertVc = UIAlertController.init(title: "确定退出？", message: nil, preferredStyle: .actionSheet)
        let sureAction = UIAlertAction.init(title: "确定", style: .default) { [weak self](UIAlertAction) in
            self?.logOut()
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVc.addAction(sureAction)
        alertVc.addAction(cancelAction)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MineSettingViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: str) as! MineSettingTableViewCell
        cell.selectionStyle = .none
        cell.leftLab.text = leftitems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChangePasswordController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MineSettingViewController {
    //MARK: - 注销登录
    private func logOut(){
        HttpClient.shareInstance.request(target: BAAPI.logoutLogin, success: { [weak self] (json) in
            //退出登录
            TProgressHUD.show(text: "退出登录")
            HttpClient.shareInstance.userSignOutByTokenOutData() //退出登录
            }
        )
    }
}
