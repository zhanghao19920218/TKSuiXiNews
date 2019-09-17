//
//  MineIntegralDetailViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let str = "MineIntegralDetailTableViewCell"

///我的兑换记录的Controller
class MineIntegralDetailViewController: BaseTableViewController {
    ///用户上方的imageView
    private lazy var _userBackgroundView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("integral_detail_top")
        return imageView
    }()
    
    ///兑换记录的Label
    private lazy var _integralLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 36)
        lab.textColor = UIColor.white
        return lab
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        getExchangeDetailInfo()
        
        navigationItem.title = "积分明细"
    }
    
    override func loadData() {
        super.loadData()
        
        getHomeData()
    }
    
    //积分数据
    func getExchangeDetailInfo(){
        HttpClient.shareInstance.request(target: BAAPI.memeberInfo, success: { [weak self](json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXMemeberInfoResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            self?._integralLabel.text = forceModel.data.score.string;
            }
        )
    }
    
    //MARK: - 初始化页面
    private func setupUI() {
        view.addSubview(_userBackgroundView)
        _userBackgroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(210 * iPHONE_AUTORATIO)
        }
        
        _userBackgroundView.addSubview(_integralLabel)
        _integralLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        _integralLabel.text = "---"
        
        let btn = UIButton()
        btn.setImage("integral_detail_coin")
        btn .setTitle("  可用积分", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = kFont(14)
        _userBackgroundView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(_integralLabel.snp_bottom).offset(10)
        }
        
        if iPhoneX || iPhoneXR || iPhoneMax {
            tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(210 * iPHONE_AUTORATIO)
                make.left.bottom.right.equalToSuperview()
            }
        } else {
            tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(210 * iPHONE_AUTORATIO - NAVIGATION_BAR_HEIGHT)
                make.left.bottom.right.equalToSuperview()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MineIntegralDetailTableViewCell.self, forCellReuseIdentifier: str)
    }

    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.integralDetail(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXIntegralDetailResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData();
            }, failure:{ [weak self] () in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.integralDetail(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXIntegralDetailResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            }
        )
    }

}

extension MineIntegralDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: str) as! MineIntegralDetailTableViewCell
        cell.selectionStyle = .none
        let model = self.dataSource[indexPath.row] as! IntegralDetailModel
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension MineIntegralDetailViewController {
    //MARK: - 请求首页数据
    private func getHomeData(){
        HttpClient.shareInstance.request(target: BAAPI.integralDetail(page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXIntegralDetailResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
            self?.tableView.reloadData();
            }
        )
    }
}

