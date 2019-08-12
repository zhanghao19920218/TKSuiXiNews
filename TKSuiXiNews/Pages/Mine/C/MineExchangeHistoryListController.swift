//
//  MineExchangeHistoryListController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let exchangeCellIdentifier = "ExchangeProductInfoCellIdentifier"
fileprivate let historyExchangeIdentifier = "ExchangeNewPersonCellIdentifier"

class MineExchangeHistoryListController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        
        navigationItem.title = "兑换记录"
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(ExchangeProductInfoCell.self, forCellReuseIdentifier: exchangeCellIdentifier)
        tableView.register(ExchangeNewPersonCell.self, forCellReuseIdentifier: historyExchangeIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.backgroundColor = RGBA(245, 245, 245, 1)
    }
    
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.exchangeProduct(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ExchangeProductListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.es.stopPullToRefresh();
            self?.tableView.reloadData();
            }, failure:{ [weak self] () in
                self?.tableView.es.stopPullToRefresh();
                self?.tableView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.exchangeProduct(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ExchangeProductListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.es.noticeNoMoreData()
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            }
        )
    }
}

extension MineExchangeHistoryListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! ExchangeProductListItemDatum
        
        if model.registerStatus.int != 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: historyExchangeIdentifier) as! ExchangeNewPersonCell
            cell.title = (model.status.string == "hidden" ? "请在现场领取礼包" : "我已现场领取")
            cell.block = { [weak self] () in
                
                self?.requestStrageReceive(id: model.id.int)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: exchangeCellIdentifier) as! ExchangeProductInfoCell
            cell.imageName = model.image.string
            cell.productTitle = model.name.string
            cell.isHiddenPick = model.status.string
            cell.score = model.score.int
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! ExchangeProductListItemDatum
        if model.registerStatus.int != 0 {
            return 125 * iPHONE_AUTORATIO
        } else {
            return 115 * iPHONE_AUTORATIO
        }
    }
    
    //MARK: - 请求现场领取
    private func requestStrageReceive(id: Int) {
        //先确定是不是退出页面
        AlertPopMenu.show(title: "温馨提醒", detail: "是否已在现场领取新人大礼包？", confirmTitle: "确定", doubleTitle: "取消", confrimBlock: { [weak self] () in
            self?.onStargeReward(id: id)
        }) {
        }
    }
}

extension MineExchangeHistoryListController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.exchangeProduct(page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ExchangeProductListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
    
    //MARK: - 现场领取奖励
    private func onStargeReward(id: Int){
        HttpClient.shareInstance.request(target: BAAPI.stargeOnShowReceive(id: id), success: { [weak self] (json) in
            TProgressHUD.show(text: "兑换成功")
            self?.pullDownRefreshData()
            }
        )
    }
}
