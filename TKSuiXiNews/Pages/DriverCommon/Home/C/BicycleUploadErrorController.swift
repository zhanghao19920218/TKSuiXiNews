//
//  BicycleUploadErrorController.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/17.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "ErrorLoadCollectionCellIdentifier"

///故障上报的Controller
class BicycleUploadErrorController: SXBaseViewController {
    ///扫描二维码或者手动输入编码
    private lazy var _scanBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    ///获取当前选中的index
    private var _currentIndex: Int?
    
    ///搜索的内容
    private var _searchContent = ""
    
    ///获取数据
    private lazy var _dataSource:Array<(imageName: String, title: String)> = {
        let array = [
            (imageName: "bicy_sit_icon", title: "坐垫"),
            (imageName: "bicy_direct_icon", title: "车头"),
            (imageName: "bicy_footer_icon", title: "脚踏"),
            (imageName: "bicy_hand_icon", title: "车把"),
            (imageName: "bicy_shut_down_icon", title: "刹车"),
            (imageName: "bicy_forbid_dusk_icon", title: "挡泥板"),
            (imageName: "bicy_lock_icon", title: "车锁"),
            (imageName: "bicy_line_icon", title: "链条"),
            (imageName: "bicy_qrcode_icon", title: "二维码"),
            (imageName: "bicy_private_lock_icon", title: "加私锁"),
            (imageName: "bicy_upload_sit_icon", title: "坐垫调节")
        ]
        return array
    }()
    
    ///扫描二维码的框子
    private lazy var _scanCodeTextV: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        view.layer.borderWidth = 1
        view.layer.borderColor = bicycleAppThemeColor.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    ///输入二维码的textField
    private lazy var _scanTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "扫描二维码或手动输入编码"
        textField.font = kFont(16 * iPHONE_AUTORATIO)
        textField.keyboardType = .numberPad
        textField.addTarget(self,
                            action: #selector(textFieldValueDidChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    ///扫描二维码按钮
    private lazy var _scanBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = bicycleAppThemeColor
        button.setImage("bicy_scan_code")
        button.imageEdgeInsets = UIEdgeInsets.init(top: 10 * iPHONE_AUTORATIO, left: 25 * iPHONE_AUTORATIO, bottom: 10 * iPHONE_AUTORATIO, right: 25 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(userClickScanCodeBtn(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///提交按钮
    private lazy var _submitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("提交")
        button.backgroundColor = RGBA(178, 178, 178, 1)
        button.titleLabel?.font = kFont(18 * iPHONE_AUTORATIO)
        button.isEnabled = false
        button.addTarget(self,
                         action: #selector(uploadInfoErrorClicked(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///设置collectionView
    private lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 92 * iPHONE_AUTORATIO, height: 100 * iPHONE_AUTORATIO)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = RGBA(245, 245, 245, 1)
        collectionView.isScrollEnabled = false;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ErrorLoadCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "故障上报"
        
        view.backgroundColor = RGBA(245, 245, 245, 1)
        
        view.addSubview(_scanBackView)
        _scanBackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(100 * iPHONE_AUTORATIO)
        }
        
        _scanBackView.addSubview(_scanCodeTextV)
        _scanCodeTextV.snp.makeConstraints { (make) in
            make.left.top.equalTo(20 * iPHONE_AUTORATIO)
            make.right.equalTo(-20 * iPHONE_AUTORATIO)
            make.height.equalTo(50 * iPHONE_AUTORATIO)
        }
        
        _scanCodeTextV.addSubview(_scanTextField)
        _scanTextField.snp.makeConstraints { (make) in
            make.left.equalTo(20 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        _scanCodeTextV.addSubview(_scanBtn)
        _scanBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(80 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_collectionView)
        _collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(_scanBackView.snp_bottom).offset(10 * iPHONE_AUTORATIO)
            make.height.equalTo(300 * iPHONE_AUTORATIO)
        }
        
        
        view.addSubview(_submitBtn)
        _submitBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-20 * iPHONE_AUTORATIO)
            make.height.equalTo(50 * iPHONE_AUTORATIO)
        }
        
    }

}

extension BicycleUploadErrorController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ErrorLoadCollectionCell
        cell.title = _dataSource[indexPath.row].title
        cell.imagename = _dataSource[indexPath.row].imageName
        if let index = _currentIndex, index == indexPath.row { cell.isSelecteds = true } else { cell.isSelecteds = false }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取点击的初始照片
        _currentIndex = indexPath.row
        _collectionView.reloadData()
        judgeCommitButton()
    }
}


extension BicycleUploadErrorController {
    @objc private func textFieldValueDidChanged(_ textField: UITextField) {
        _searchContent = textField.text ?? ""
        judgeCommitButton()
    }
    
    ///判断提交按钮
    private func judgeCommitButton(){
        if !_searchContent.isEmpty && _currentIndex != nil {
            _submitBtn.isEnabled = true
            _submitBtn.backgroundColor = bicycleAppThemeColor
        } else {
            _submitBtn.isEnabled = false
            _submitBtn.backgroundColor = RGBA(178, 178, 178, 1)
        }
    }
    
    @objc private func uploadInfoErrorClicked(_ sender: UIButton) {
        TProgressHUD.show(text: "请输入正确的单车编号")
    }
    
    ///用户点击扫码开锁按钮
    @objc private func userClickScanCodeBtn(_ sender: UIButton) {
        let vc = ScannerVC()
        vc.setupScanner("扫描单车", bicycleAppThemeColor, .default, "对准单车二维码，即可自动扫描解锁") { (code) in
            TProgressHUD.show(text: "请扫描单车二维码")
            
            //关闭扫描界面
            self.dismiss(animated: true, completion: nil)
        }
        
        //Present到扫描界面
        present(vc, animated: true, completion: nil)
    }
}
