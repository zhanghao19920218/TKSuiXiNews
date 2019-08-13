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
fileprivate let newsNoPicIdentifier = "HomeNewsNoPicCellIdentifier"

class HomeNewsListViewController: BaseTableViewController {
    //banner的model
    private var model: HomeVVideoBannerResponse?

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
        tableView.register(HomeNewsNoPicCell.self, forCellReuseIdentifier: newsNoPicIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
    
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
        
        requestBanner()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: searchTitleIdentifier) as! HomeNewsSearchInfoCell
            cell.block = { [weak self] () in
                let vc = HomeSearchListViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell;
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerIdentifier) as! HomeVVideoBannerCell;
            if let model = model { cell.images = model.data }
            cell.block = { [weak self] (model) in
                let vc = HomeBannerDetailViewController()
                if !model.content.string.isEmpty {
                    vc.loadUrl = model.content.string
                    vc.name = model.name.string
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell;
        }
        
        let model = dataSource[indexPath.row - 2] as! HomeNewsListModel
        
        if !model.image.string.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell;
            cell.title = model.name.string
            cell.imageName = model.image.string
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.begintime.string
            return cell;
        } else if model.images.count == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsThreePicIdentifier) as! HomeNewsThreePictureCell;
            cell.title = model.name.string
            cell.imageName = model.images[0]
            cell.imageName2 = model.images[1]
            cell.imageName3 = model.images[2]
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.begintime.string
            return cell;
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: newsNoPicIdentifier) as! HomeNewsNoPicCell
        cell.title = model.name.string
        cell.isLike = model.likeStatus.int
        cell.like = model.likeNum.int
        cell.review = model.visitNum.int
        cell.time = model.begintime.string
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40 * iPHONE_AUTORATIO;
        }
        if indexPath.row == 1 {
            return 188 * iPHONE_AUTORATIO;
        }
        
        let model = dataSource[indexPath.row - 2] as! HomeNewsListModel
        
        if !model.image.string.isEmpty {
            return 118 * iPHONE_AUTORATIO
        }
        
        if model.images.count == 3 {
            return 187 * iPHONE_AUTORATIO
        } else {
            return 118 * iPHONE_AUTORATIO
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 2 {
            let model = dataSource[indexPath.row - 2] as! HomeNewsListModel;
            let vc = HomeNewsDetailInfoController();
            vc.id = model.id.string
            parent?.navigationController?.pushViewController(vc, animated: true);
        }
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
    
    //MARK: - 请求Banner
    private func requestBanner() {
        HttpClient.shareInstance.request(target: BAAPI.topBanner(module: "新闻"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeVVideoBannerResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel
            self?.tableView.reloadData();
            }
        )
    }
}
