//
//  ScoreMallController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 积分商城
 */
fileprivate let fontSize = kFont(12 * iPHONE_AUTORATIO)

fileprivate let cellIdentifier = "MallProductCollectionViewCellIdentifier"

class ScoreMallController: BaseCollectionViewController {
    private lazy var topView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("mine_info_back")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
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
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = .white
        return label
    }()
    
    //积分的icon
    private lazy var scoreIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("score_icon")
        return imageView
    }()
    
    //积分的label
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.text = "积分 0"
        label.textColor = .white
        return label
    }()
    
    //抽积分
    private lazy var getScoreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = RGBA(245, 182, 32, 1)
        button.titleLabel?.font = kFont(11 * iPHONE_AUTORATIO)
        button.setTitle("抽积分")
        button.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        button.setTitleColor(.white)
        button.addTarget(self,
                         action: #selector(scoreButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var scoreRuleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = RGBA(85, 147, 255, 1)
        button.titleLabel?.font = kFont(11 * iPHONE_AUTORATIO)
        button.setTitle("积分规则")
        button.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        button.setTitleColor(.white)
        button.addTarget(self,
                         action: #selector(scoreRuleButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setupUI()
        
        navigationItem.title = "积分商城"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }

    //MARK: - 初始化
    private func _setupUI() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(311 * iPHONE_AUTORATIO);
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(180 * iPHONE_AUTORATIO)
            make.left.right.bottom.equalToSuperview()
        }
        collectionView.register(MallProductCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //用户头像
        topView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.top.equalTo(79 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 80 * iPHONE_AUTORATIO, height: 80 * iPHONE_AUTORATIO))
        }
        
        //用户昵称
        topView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(116 * iPHONE_AUTORATIO)
            make.top.equalTo(93 * iPHONE_AUTORATIO)
        }
        nicknameLabel.text = ""
        
        //积分的icon
        topView.addSubview(scoreIcon)
        scoreIcon.snp.makeConstraints { (make) in
            make.left.equalTo(115 * iPHONE_AUTORATIO)
            make.top.equalTo(nicknameLabel.snp_bottom).offset(26 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 10 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO))
        }
        
        topView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(scoreIcon.snp_right).offset(5 * iPHONE_AUTORATIO)
            make.centerY.equalTo(scoreIcon.snp_centerY)
        }
        
        topView.addSubview(getScoreButton)
        getScoreButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(89 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 60 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO))
        }
        
        topView.addSubview(scoreRuleButton)
        scoreRuleButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(getScoreButton.snp_bottom).offset(17 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 60 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO))
        }
    }
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.scoreItemList(p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MallListProductItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.collectionView.es.stopPullToRefresh();
            self?.collectionView.reloadData();
            }, failure:{ [weak self] () in
                self?.collectionView.es.stopPullToRefresh();
                self?.collectionView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.scoreItemList(p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MallListProductItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.collectionView.es.stopLoadingMore();
                self?.collectionView.reloadData();
            } else {
                //没有更多数据
                self?.collectionView.es.noticeNoMoreData();
            }
            
            }, failure:{ [weak self] () in
                self?.collectionView.es.stopLoadingMore();
                self?.collectionView.reloadData();
            }
        )
    }
    
    //MARK: - 点击抽积分按钮
    @objc private func scoreButtonTapped(_ sender: UIButton) {
        let vc = RotatePanelScoreController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func scoreRuleButtonTapped(_ sender: UIButton) {
        let vc = ScoreRuleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ScoreMallController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.row] as! MallListProductItemModel
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MallProductCollectionViewCell
        cell.imageName = model.image.string
        cell.productName = model.name.string
        cell.score = model.score.int
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! MallListProductItemModel
        let vc = ScoreProductDetailViewController()
        vc.productId = model.id.int
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165 * iPHONE_AUTORATIO, height: 175 * iPHONE_AUTORATIO)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15 * iPHONE_AUTORATIO, left: 15 * iPHONE_AUTORATIO, bottom: 15 * iPHONE_AUTORATIO, right: 15 * iPHONE_AUTORATIO)
    }
}

extension ScoreMallController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.scoreItemList(p: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MallListProductItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.collectionView.reloadData();
            }
        )
        
        HttpClient.shareInstance.request(target: BAAPI.memeberInfo, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MemeberInfoResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.avatarImageView.kf.setImage(with: URL(string: forceModel.data.avatar.string), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            self?.nicknameLabel.text = forceModel.data.nickname.string
            self?.scoreLabel.text = "积分 \(forceModel.data.score.int)";
            }
        )
    }
}
