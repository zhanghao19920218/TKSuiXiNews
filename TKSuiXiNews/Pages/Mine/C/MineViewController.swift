//
//  MineViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {
    
    private var infoModel : MemberInfoModel?
    
    //设置背景的view
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("mine_info_back");
        return imageView;
    }();
    
    //头像
    private lazy var avatarImageView:UIImageView = {
        let imageView = UIImageView();
        imageView.layer.cornerRadius = 40 * iPHONE_AUTORATIO;
        imageView.layer.masksToBounds = true;
        imageView.layer.borderWidth = 3 * iPHONE_AUTORATIO;
        imageView.layer.borderColor = RGBA(255, 102, 103, 1).cgColor
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE);
        return imageView;
    }();
    
    //昵称
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.textAlignment = .center;
        label.text = ""
        return label;
    }();
    
    //号码的背景
    private lazy var mobileLabelBack: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(229, 49, 66, 1)
        view.layer.cornerRadius = 12 * iPHONE_AUTORATIO;
        return view;
    }();
    
    //号码
    private lazy var mobileLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = RGBA(255, 158, 168, 1)
        label.textAlignment = .center;
        label.text = "0"
        return label;
    }();
    
    //积分按钮
    private lazy var scoreBackButton: ScroreItemButton = {
        let button = ScroreItemButton(type: .custom);
        button.layer.cornerRadius = 19 * iPHONE_AUTORATIO;
        button.backgroundColor = .white;
        button.layer.shadowOffset = CGSize(width: 1 , height: 1)
        button.layer.shadowOpacity = 0.5;
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(clickIntegralDetailAction), for: .touchUpInside)
        return button;
    }();
    
    //下方的vIEW
    private lazy var mineCollectionView: MineCollectionView = {
        let view = MineCollectionView()
        return view;
    }();
    
    //设置右侧的navigationItem
    private lazy var rightNavigatorItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("setting_icon"), for: .normal);
        button.frame = CGRect(x: 0, y: 0, width: 30 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO)
        button.addTarget(self, action: #selector(self.clickSettingAction), for: .touchUpInside)
        return button;
    }();
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNavigationBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        //设置背景透明
//        setupTransaleBar();
        
        setupUI()
        
        requestData()
        
        configureNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: NSNotification.Name(rawValue: "refreshMemberInfo"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    //初始化navigationBar
    private func configureNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigatorItem);
    }
    
    
    //MARK: - 设置透明NavigationBar
//    private func setupTransaleBar(){
//        navigationController?.navigationBar.isTranslucent = true;
//    }
    

    //MARK: -更新个人页面背景
    private func setupUI(){
        
        view.addSubview(backImageView);
        backImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalTo(0);
            make.height.equalTo(311 * iPHONE_AUTORATIO);
        };
        backImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.clickInfoAction))
        backImageView.addGestureRecognizer(tap)
        
        //头像
        view.addSubview(avatarImageView);
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(94 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 80 * iPHONE_AUTORATIO, height: 80 * iPHONE_AUTORATIO))
        };
        
        //用户名
        view.addSubview(nicknameLabel);
        nicknameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(avatarImageView.snp_bottom).offset(15 * iPHONE_AUTORATIO);
        };
        
        //电话号码背景
        view.addSubview(mobileLabelBack);
        mobileLabelBack.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(nicknameLabel.snp_bottom).offset(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 100 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO))
        }
        
        //手机号码
        mobileLabelBack.addSubview(mobileLabel);
        mobileLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
        }
        
        //积分
        view.addSubview(scoreBackButton);
        scoreBackButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(285 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 152 * iPHONE_AUTORATIO, height: 38 * iPHONE_AUTORATIO))
        };
        
        //下方的collectionView
        view.addSubview(mineCollectionView);
        mineCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scoreBackButton.snp_bottom).offset(17 * iPHONE_AUTORATIO);
            make.left.right.equalToSuperview();
            make.height.equalTo(200 * iPHONE_AUTORATIO)
        }
        //CollectionViewCell点击
        mineCollectionView.mb = {(index:Int)->(Void) in
            if index == 0 {
                //我的收藏
                let vc = MineCollectionViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if(index == 7){
                //关于我们
                let vc = AboutUsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //点击设置按钮
    @objc public func clickSettingAction(){
        let vc = MineSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //进入个人中心
    @objc func clickInfoAction(){
        let vc = MineInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.infoModel = self.infoModel
    }
    
    //进入积分明细
    @objc func clickIntegralDetailAction(){
        let vc = MineIntegralDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MineViewController {
    //MARK: - 请求个人中心数据
    @objc private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.memeberInfo, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MemeberInfoResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            self?.infoModel = model?.data
            var avatar = forceModel.data.avatar.string
            if !avatar.contains("http") || !avatar.contains("https"){
                avatar = K_URL_Base + avatar
            }
            self?.avatarImageView.kf.setImage(with: URL(string: avatar), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            self?.nicknameLabel.text = forceModel.data.nickname.string
            self?.mobileLabel.text = forceModel.data.mobile.string
            self?.scoreBackButton.score = forceModel.data.score.string;
            }
        )
    }
}