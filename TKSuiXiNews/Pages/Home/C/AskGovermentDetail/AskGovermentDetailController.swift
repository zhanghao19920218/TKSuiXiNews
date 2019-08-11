//
//  AskGovermentDetailController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * MARK: - 详细问政的Controller
 */

fileprivate let normalCellIdentifier = "AskGovermentDetailNormalCellIdentifier"
fileprivate let contentCellIdentifier = "AskGovermentContentCellIdentifier"
fileprivate let photoCellIdentifier = "AskGovermentAddPhotosCellIdentifier"

class AskGovermentDetailController: BaseViewController {
    //置顶的model
    var topModel: ArticleAdminModelResponse?
    
    private var moduleSecond = ""
    
    private var name: String = ""
    
    private var content:String = ""
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发 布")
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.setTitleColor(.white)
        button.backgroundColor = RGBA(255, 74, 92, 1)
        button.addTarget(self,
                         action: #selector(tapSendGovernmentButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        tableView.register(AskGovermentDetailNormalCell.self, forCellReuseIdentifier: normalCellIdentifier)
        tableView.register(AskGovermentContentCell.self, forCellReuseIdentifier: contentCellIdentifier)
        tableView.register(AskGovermentAddPhotosCell.self, forCellReuseIdentifier: photoCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var titleArray:[String] = {
        return ["问政对象", "标题"]
    }()
    
    private lazy var placeHolder: [String] = {
        return ["选择问政对象", "请输入标题"]
    }()
    
    private lazy var images: [String] = {
        return [String]()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "发布问政"
        
        view.backgroundColor = RGBA(244, 244, 244, 1)
        
        setupUI()
        
        requestBanner()
    }

    private func setupUI() {
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(49 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-65 * iPHONE_AUTORATIO)
        }
    }
    
    //MARK: - 选择更多照片
    private func selectedMorePhotos() {
        let maxCount = 9 - images.count; //确定最大的照片数量
        YPImagePickerUtil.share.multiPickerPhotosLibary(maxCount: maxCount);
        YPImagePickerUtil.share.delegate = self;
    }
    
    //MARK: - 点击发布按钮
    @objc private func tapSendGovernmentButton(_ sender: UIButton) {
        if moduleSecond.isEmpty {
            TProgressHUD.show(text: "请选择问政对象")
            return
        }
        
        if name.isEmpty {
            TProgressHUD.show(text: "请输入标题")
            return
        }
        
        if content.isEmpty {
            TProgressHUD.show(text: "请输入问政内容")
            return
        }
        
        //发布问政
        sendAskGovRequest()
        
    }
}

extension AskGovermentDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier) as! AskGovermentDetailNormalCell
            cell.title = titleArray[indexPath.row]
            cell.placeholder = placeHolder[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            cell.textField.addTarget(self,
                                     action: #selector(textFieldValueDidChanged(_:)),
                                     for: .editingChanged)
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier) as! AskGovermentContentCell
            cell.textView.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: photoCellIdentifier) as! AskGovermentAddPhotosCell
        cell.images = images
        cell.chooseBlock = { [weak self] () in
            self?.selectedMorePhotos()
        }
        cell.deleteBlock = { [weak self] (index) in
            self?.images.remove(at: index)
            self?.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 1 {
            return 53 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 2 {
            return 190 * iPHONE_AUTORATIO
        }
        
        return 350 * iPHONE_AUTORATIO
    }
    
}

extension AskGovermentDetailController: YPImagePickerUtilDelegate {
    func imagePicker(imageUrl: String, videoUrl: String, videoLength: Int, isSuccess: Bool) {
    }
    
    func imagePicker(imageUrl: String, isSuccess: Bool) {
    }
    
    //选择增加照片
    func imagePicker(images: [String], isSuccess: Bool) {
        //更新照片图库
        self.images += images
        tableView.reloadData() //刷新页面
    }
}

extension AskGovermentDetailController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            //出现选择问政的弹窗
            AskGovPopMenu.show(array: topModel?.data ?? []) { [weak textField, weak self] (content) in
                textField?.text = content
                //获取问政对象
                self?.moduleSecond = content
            }
            
            return false
        }
        return true
    }
    
    @objc func textFieldValueDidChanged(_ sender: UITextField) {
        if sender.tag == 1 {
            name = sender.text ?? ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 20 {
            if let str = textView.text {
                //截取前20个字符
                let subStr = str.prefix(20)
                textView.text = String(subStr)
                content = String(subStr)
            }
        } else {
            content = textView.text ?? ""
        }
    }
}

extension AskGovermentDetailController {
    //MARK: - 请求矩阵
    private func requestBanner() {
        HttpClient.shareInstance.request(target: BAAPI.articleAdmin(module: "专栏"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ArticleAdminModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.topModel = forceModel
            }
        )
    }
    
    //MARK: - 发布问政
    private func sendAskGovRequest() {
        HttpClient.shareInstance.request(target: BAAPI.sendAskGoverment(moduleSecond: moduleSecond, name: name, content: content, images: images), success: { [weak self] (json) in
            self?.popViewControllerBtnPressed() //返回上一个页面
            TProgressHUD.show(text: "发布问政成功")
        })
    }
}
