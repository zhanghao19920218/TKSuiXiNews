//
//  MineViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///我的Controller
class SXMineViewController: SXBaseViewController {
    
    ///用户的model
    private var _model : SXMemberInfoModel?
    
    //设置背景的view
    private lazy var _minebackImageView: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("mine_info_back");
        return imageView;
    }();
    
    ///头像的imageView
    private lazy var _userAvatarImageView:UIImageView = {
        let imageView = UIImageView();
        imageView.layer.cornerRadius = 40 * iPHONE_AUTORATIO;
        imageView.layer.masksToBounds = true;
        imageView.layer.borderWidth = 3 * iPHONE_AUTORATIO;
        imageView.layer.borderColor = RGBA(255, 102, 103, 1).cgColor
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView;
    }();
    
    //昵称的Label
    private lazy var _nicknameLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.textAlignment = .center;
        label.text = ""
        return label;
    }();
    
    //号码的背景
    private lazy var _mobileLabelBackV: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(229, 49, 66, 1)
        view.layer.cornerRadius = 12 * iPHONE_AUTORATIO;
        return view;
    }();
    
    //号码
    private lazy var _mobileLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = RGBA(255, 158, 168, 1)
        label.textAlignment = .center;
        label.text = "0"
        return label;
    }();
    
    //积分按钮
    private lazy var scoreBackButton: SXScroreItemButton = {
        let button = SXScroreItemButton(type: .custom);
        button.layer.cornerRadius = 19 * iPHONE_AUTORATIO;
        button.backgroundColor = .white;
        button.layer.shadowOffset = CGSize(width: 1 , height: 1)
        button.layer.shadowOpacity = 0.5;
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(clickIntegralDetailAction), for: .touchUpInside)
        return button;
    }();
    
    //下方的vIEW
    private lazy var mineCollectionView: SXMineCollectionView = {
        let view = SXMineCollectionView()
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
        setupNaviBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        setupUI()
        
        configureNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getHomeData), name: NSNotification.Name(rawValue: "refreshMemberInfo"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
        
        getHomeData()
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
        //初始化navigationBar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    

    //MARK: -更新个人页面背景
    private func setupUI(){
        
        view.addSubview(_minebackImageView);
        _minebackImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalTo(0);
            make.height.equalTo(311 * iPHONE_AUTORATIO);
        };
        _minebackImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.clickInfoAction))
        _minebackImageView.addGestureRecognizer(tap)
        
        //头像
        view.addSubview(_userAvatarImageView);
        _userAvatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(94 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 80 * iPHONE_AUTORATIO, height: 80 * iPHONE_AUTORATIO))
        };
        
        //用户名
        view.addSubview(_nicknameLabel);
        _nicknameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(_userAvatarImageView.snp_bottom).offset(15 * iPHONE_AUTORATIO);
        };
        
        //电话号码背景
        view.addSubview(_mobileLabelBackV);
        _mobileLabelBackV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(_nicknameLabel.snp_bottom).offset(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 100 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO))
        }
        
        //手机号码
        _mobileLabelBackV.addSubview(_mobileLabel);
        _mobileLabel.snp.makeConstraints { (make) in
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
        mineCollectionView.mineBlock = {[weak self](index:Int)->(Void) in
            if index == 0 {
                //我的收藏
                let vc = SXMineFavoriteListController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if index == 4 {
                let vc = SXMessageViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                
            } else if index == 1 {
                //最近浏览
                let vc = SXMineReviewListController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if index == 5 {
                //兑换记录
                let vc = SXMineExchangeHistoryListController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if(index == 6){
                //关于我们
                let vc = SXAboutUsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if index == 2 {
                //我的帖子
                let vc = MineSendArticlesController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if index == 3 {
                //问政记录
                let vc = SXMineAskGovListViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //点击设置按钮
    @objc public func clickSettingAction(){
        let vc = SXMineSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //进入个人中心
    @objc func clickInfoAction(){
        let vc = SXMineInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.userInfoModel = self._model
    }
    
    //进入积分明细
    @objc func clickIntegralDetailAction(){
        let vc = SXMineIntegralDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension SXMineViewController {
    //MARK: - 请求个人中心数据
    @objc private func getHomeData(){
        HttpClient.shareInstance.request(target: BAAPI.memeberInfo, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXMemeberInfoResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            self?._model = model?.data
            let avatar = forceModel.data.avatar.string
            self?._userAvatarImageView.kf.setImage(with: URL(string: avatar), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            self?._nicknameLabel.text = forceModel.data.nickname.string
            self?._mobileLabel.text = forceModel.data.mobile.string
            self?.scoreBackButton.score = forceModel.data.score.string
            
            //未读消息数量
            self?.mineCollectionView.unreadMsgNum = forceModel.data.unread.int
            
            //更新手机号码
            DefaultsKitUtil.share.storePhoneNum(mobile: forceModel.data.mobile.string)
            }
        )
    }
}
