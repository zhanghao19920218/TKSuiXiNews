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

class MineInfoViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    private var leftArray = [String]()
//    private var rightArray = [String]()
    public var infoModel : MemberInfoModel?
    
    private var avatar : String?
    private var nickname : String?
    
    private lazy var pickerVc : UIImagePickerController = {
        let vc = UIImagePickerController()
        return vc
    }()
    
    private lazy var bottomBtn : UIButton = {
        let btn = UIButton()
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
        tableView.register(MineSettingTableViewCell.self, forCellReuseIdentifier: str)
        tableView.backgroundColor = RGB(244, 245, 247)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        leftArray = ["头像","昵称","手机号"]
        avatar = infoModel?.avatar.string
        nickname = infoModel?.nickname.string
        SevenBeefUpload.share.getSevenBeefToken() //请求七牛云token
        createView()
    }
    
    func createView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalToSuperview()
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
    
    //mark --- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        guard let data = image.jpegData(compressionQuality: 0.75) else {
            return;
        }
        uploadDetailImage(imageData: data,image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    //上传图像
    private func uploadDetailImage(imageData:Data,image:UIImage){
        SevenBeefUpload.share.uploadSingleImage(image) { [weak self](fileUrl) in
            
            self?.avatar = fileUrl
            let cell = self?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! MineSettingTableViewCell
            cell.iconImageView.image = image
        }
    }
    
    //保存按钮
    @objc func clickSaveAction() {
        if avatar == infoModel?.avatar.string  && nickname == infoModel?.nickname.string{
            TProgressHUD.show(text: "请填写修改内容")
        }else{
            HttpClient.shareInstance.request(target: BAAPI.changeMemberInfo(avatar: avatar ?? "", nickname: nickname ?? ""), success: { [weak self] (json) in
                NotificationCenter.default.post(name: NSNotification.Name.init("refreshMemberInfo"), object: nil);
                self?.popViewControllerBtnPressed()
                TProgressHUD.show(text: "修改成功")
                
                }
            )
        }
    }

}

extension MineInfoViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: str) as! MineSettingTableViewCell
        cell.selectionStyle = .none
        cell.leftLab.text = leftArray[indexPath.row]
        if indexPath.row == 0 {
            cell.iconImageView.isHidden = false
            cell.rightImageView.isHidden = true
            let avatar = infoModel?.avatar.string ?? ""
            cell.iconImageView.kf.setImage(with: URL(string: avatar), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
        }else if indexPath.row == 1{
            cell.rightLab.isHidden = false
            cell.rightImageView.isHidden = true
            cell.rightLab.text = infoModel?.nickname.string
        }else{
            cell.rightSubLab.isHidden = false
            cell.rightSubLab.text = infoModel?.mobile.string
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
                self.pickerVc.sourceType = .camera
                self.pickerVc.delegate = self
                self.present(self.pickerVc, animated: true, completion: nil)
            }
            let photoAction = UIAlertAction.init(title: "相册", style: .default) { (UIAlertAction) in
                self.pickerVc.sourceType = .photoLibrary;
                self.pickerVc.delegate = self
                self.present(self.pickerVc, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alertVc.addAction(cameraAction)
            alertVc.addAction(photoAction)
            alertVc.addAction(cancelAction)
            self.present(alertVc, animated: true, completion: nil)
        }else if indexPath.row == 1{
            let alertVc = UIAlertController.init(title: "修改昵称", message: nil, preferredStyle: .alert)
            alertVc.addTextField { (textField) in
                textField.placeholder = "请输入昵称"
            }
            let sureAction = UIAlertAction.init(title: "确定", style: .default) { (UIAlertAction) in
                let tf = alertVc.textFields?.first
                if tf?.text?.count == 0 {
                    return
                }
                self.nickname = tf?.text
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! MineSettingTableViewCell
                cell.rightLab.text = tf?.text
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alertVc.addAction(sureAction)
            alertVc.addAction(cancelAction)
            self.present(alertVc, animated: true, completion: nil)
        }else{
            let vc = ChangeBindingViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
