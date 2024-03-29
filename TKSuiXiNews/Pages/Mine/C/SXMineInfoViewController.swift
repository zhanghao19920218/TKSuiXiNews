//
//  MineInfoViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

import AVFoundation

import AssetsLibrary

import Photos


fileprivate let str = "MineSettingTableViewCell"

class SXMineInfoViewController: SXBaseViewController {
    
    private lazy var leftSideList: [String] = {
        return ["头像","昵称","手机号"]
    }()
    
    public var userInfoModel : SXMemberInfoModel?
    
    ///头像
    private lazy var _avatar : String? = {
       return userInfoModel?.avatar.string
    }()
    
    ///昵称
    private lazy var _nickname : String? = {
        return userInfoModel?.nickname.string
    }()
    
    private lazy var _imagePickerVC : UIImagePickerController = {
        let vc = UIImagePickerController()
        return vc
    }()
    
    private lazy var _bottomButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = RGB(255, 74, 92)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = kFont(16)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(self.clickSaveAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(SXMineSettingCell.self, forCellReuseIdentifier: str)
        tableView.backgroundColor = RGB(244, 245, 247)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "个人资料"
        
        SevenBeefUpload.share.getSevenBeefToken() //请求七牛云token
        
        createView()
    }
    
    private func createView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(_bottomButton)
        _bottomButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
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
    
    //上传图像
    private func uploadDetailImage(imageData:Data,image:UIImage){
        SevenBeefUpload.share.uploadSingleImage(image) { [weak self](fileUrl) in
            
            self?._avatar = fileUrl
            let cell = self?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! SXMineSettingCell
            cell._iconImgView.image = image
        }
    }
    
    //保存按钮
    @objc func clickSaveAction() {
        if _avatar == userInfoModel?.avatar.string  && _nickname == userInfoModel?.nickname.string{
            TProgressHUD.show(text: "请填写修改内容")
        }else{
            HttpClient.shareInstance.request(target: BAAPI.changeMemberInfo(avatar: _avatar ?? "", nickname: _nickname ?? ""), success: { [weak self] (json) in
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshMemberInfo"), object: nil);
                self?.popViewControllerBtnPressed()
                TProgressHUD.show(text: "修改成功")
                
                }
            )
        }
    }

}

extension SXMineInfoViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftSideList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: str) as! SXMineSettingCell
        cell.selectionStyle = .none
        cell.leftLab.text = leftSideList[indexPath.row]
        if indexPath.row == 0 {
            cell._iconImgView.isHidden = false
            cell._rightImgV.isHidden = true
            let avatar = userInfoModel?.avatar.string ?? ""
            cell._iconImgView.kf.setImage(with: URL(string: avatar), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
        }else if indexPath.row == 1{
            cell._rightLab.isHidden = false
            cell._rightImgV.isHidden = true
            cell._rightLab.text = userInfoModel?.nickname.string
        }else{
            cell._rightSubLab.isHidden = false
            cell._rightSubLab.text = userInfoModel?.mobile.string
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else{
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertVc = UIAlertController.init(title: "选择来源", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction.init(title: "相机", style: .default) { (UIAlertAction) in
                if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                    TProgressHUD.show(text: "获取相机权限失败，请打开权限")
                    return
                }
                self._imagePickerVC.sourceType = .camera
                self._imagePickerVC.delegate = self
                self.present(self._imagePickerVC, animated: true, completion: nil)
            }
            let photoAction = UIAlertAction.init(title: "相册", style: .default) { (UIAlertAction) in
                self._imagePickerVC.sourceType = .photoLibrary;
                self._imagePickerVC.delegate = self
                self.present(self._imagePickerVC, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alertVc.addAction(cameraAction)
            alertVc.addAction(photoAction)
            alertVc.addAction(cancelAction)
            self.present(alertVc, animated: true, completion: nil)
        }else if indexPath.row == 1{
            let alertVc = UIAlertController.init(title: "修改昵称", message: nil, preferredStyle: .alert)
            alertVc.addTextField { [weak self](textField) in
                textField.placeholder = "请输入昵称"
                textField.addTarget(self,
                                    action: #selector(self?.textFieldValueDidChanged(_:)),
                                    for: .editingChanged)
            }
            let sureAction = UIAlertAction.init(title: "确定", style: .default) { (UIAlertAction) in
                let tf = alertVc.textFields?.first
                if tf?.text?.count == 0 {
                    return
                }
                self._nickname = tf?.text
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! SXMineSettingCell
                cell._rightLab.text = tf?.text
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alertVc.addAction(sureAction)
            alertVc.addAction(cancelAction)
            self.present(alertVc, animated: true, completion: nil)
        }else{
            let vc = SXChangeBindingViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - 监听textField昵称的数据长度
    @objc private func textFieldValueDidChanged(_ textField: UITextField) {
        let content = textField.text ?? ""
        if content.count >= 7 {
            let result = content.prefix(7)
            textField.text = String(result)
        }
    }
}

extension SXMineInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //mark --- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        guard let data = image.jpegData(compressionQuality: 0.75) else {
            return;
        }
        uploadDetailImage(imageData: data,image: image)
        self.dismiss(animated: true, completion: nil)
    }
}
