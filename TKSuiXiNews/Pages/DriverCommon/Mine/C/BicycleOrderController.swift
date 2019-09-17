//
//  BicycleOrderController.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "TKBicycleSingleCellIdentifier"

///我的订单界面

class BicycleOrderController: BaseTableViewController {
    //banner的model
    private var model: HomeVVideoBannerResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        
        navigationItem.title = "我的订单"
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(TKBicycleSingleCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.backgroundColor = RGBA(245, 245, 245, 1)
        if let _ = tableView.mj_header {
            tableView.mj_header.backgroundColor = bicycleAppThemeColor
        }
    }
    
    
    override func loadData() {
        super.loadData();
        
        requestData()
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.orderLists(p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BicycleOrderListResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
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
        HttpClient.shareInstance.request(target: BAAPI.orderLists(p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BicycleOrderListResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.mj_footer.resetNoMoreData()
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            }
        )
    }
}

extension BicycleOrderController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! BicycleOrderListModel
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TKBicycleSingleCell
        cell.createTime = model.createtime.string
        cell.orderLength = model.time.string
        cell.orderPrice = model.money.string
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168 * iPHONE_AUTORATIO
    }
}

extension BicycleOrderController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.orderLists(p: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BicycleOrderListResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
            self?.tableView.reloadData();
        })
    }
}
