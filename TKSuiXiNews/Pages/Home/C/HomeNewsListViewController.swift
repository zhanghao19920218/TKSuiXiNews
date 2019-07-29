//
//  HomeNewsListViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let bannerIdentifier = "HomeVVideoBannerCellIdentifier";
fileprivate let searchTitleIdentifier = "HomeNewsSearchInfoCellIdentifier";
fileprivate let newsOnePicIdentifier = "HomeNewsOnePictureCellIdentifier"
fileprivate let newsThreePicIdentifier = "HomeNewsThreePictureCellIdentifier"

class HomeNewsListViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(HomeVVideoBannerCell.self, forCellReuseIdentifier: bannerIdentifier);
        tableView.register(HomeNewsSearchInfoCell.self, forCellReuseIdentifier: searchTitleIdentifier)
        tableView.register(HomeNewsOnePictureCell.self, forCellReuseIdentifier: newsOnePicIdentifier)
        tableView.register(HomeNewsThreePictureCell.self, forCellReuseIdentifier: newsThreePicIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
    
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "新闻", page: page), success:{ [weak self] (json) in
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
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "新闻", page: page), success:{ [weak self] (json) in
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

extension HomeNewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: searchTitleIdentifier) as! HomeNewsSearchInfoCell;
            return cell;
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerIdentifier) as! HomeVVideoBannerCell;
            return cell;
        }
        
        let model = dataSource[indexPath.row - 2] as! HomeNewsListModel
        
        if model.image.count == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell;
            cell.title = model.name.string
            cell.imageName = model.image[0]
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.begintime.string
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsThreePicIdentifier) as! HomeNewsThreePictureCell;
            cell.title = model.name.string
            cell.imageName = model.image[0]
            cell.imageName2 = model.image[1]
            cell.imageName3 = model.image[2]
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.begintime.string
            return cell;
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40 * iPHONE_AUTORATIO;
        }
        if indexPath.row == 1 {
            return 188 * iPHONE_AUTORATIO;
        }
        
        let model = dataSource[indexPath.row - 2] as! HomeNewsListModel
        
        if model.image.count == 1 {
            return 118 * iPHONE_AUTORATIO
        } else {
            return 187 * iPHONE_AUTORATIO
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = dataSource[indexPath.row - 1] as! VVideoListModel;
//        let vc = DetailVideoInfoController();
//        vc.id = model.id.string
//        parent?.navigationController?.pushViewController(vc, animated: true);
    }
}

extension HomeNewsListViewController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "新闻", page: page), success: { [weak self] (json) in
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
