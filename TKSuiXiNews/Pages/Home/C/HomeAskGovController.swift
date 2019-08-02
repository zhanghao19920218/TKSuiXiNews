//
//  HomeAskGovController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 问政
 */
fileprivate let cellIdentifier = "HomeAskGovOnePicCellIdentifier"
fileprivate let cellTextIdentifier = "HomeAskNonePicCellIdentifier"
fileprivate let cellThreePicIdentifier = "HomeAskThreePicCellIdentifier"

class HomeAskGovController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    //初始化tableView
    private func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeAskGovOnePicCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(HomeAskNonePicCell.self, forCellReuseIdentifier: cellTextIdentifier)
        tableView.register(HomeAskThreePicCell.self, forCellReuseIdentifier: cellThreePicIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "问政", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "问政", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
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
                self?.tableView.es.noticeNoMoreData();
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            }
        )
    }
}

extension HomeAskGovController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! HomeNewsListModel
        
        if model.images.count == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellThreePicIdentifier) as! HomeAskThreePicCell
            cell.title = model.name.string
            cell.imageName = model.images[0]
            cell.imageName2 = model.images[1]
            cell.imageName3 = model.images[2]
            cell.time = model.begintime.string
            cell.comment = model.visitNum.int
            return cell
        } else if !model.image.string.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeAskGovOnePicCell
            cell.title = model.name.string
            cell.imageName = model.image.string
            cell.time = model.begintime.string
            cell.comment = model.visitNum.int
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTextIdentifier) as! HomeAskNonePicCell
        cell.title = model.name.string
        cell.time = model.begintime.string
        cell.comment = model.visitNum.int
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! HomeNewsListModel
        if model.images.count == 3 {
            return 193 * iPHONE_AUTORATIO
        }
        
        return 111 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! HomeNewsListModel;
        let vc = HomeNewsDetailInfoController();
        vc.id = model.id.string
        parent?.navigationController?.pushViewController(vc, animated: true);
    }
}


extension HomeAskGovController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "问政", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
}
