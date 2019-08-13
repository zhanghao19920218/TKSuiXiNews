//
//  HomeVVideoController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * V视频
 */
fileprivate let bannerIdentifier = "HomeVVideoBannerCellIdentifier";
fileprivate let normalIdentifier = "HomeVVideoNormalCellIdentifier";

class HomeVVideoController: BaseTableViewController {
    //banner的model
    private var model: HomeVVideoBannerResponse?
    
    private lazy var images:[HomeVVideoBannerDatum] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()

        requestBanner()
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(HomeVVideoBannerCell.self, forCellReuseIdentifier: bannerIdentifier);
        tableView.register(HomeVVideoNormalCell.self, forCellReuseIdentifier: normalIdentifier)
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
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "V视频", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(VVideoListResponseModel.self, from: json)
            guard let forceModel = model else {
                self?.tableView.es.stopPullToRefresh();
                self?.tableView.reloadData();
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
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "V视频", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(VVideoListResponseModel.self, from: json)
            guard let forceModel = model else {
                self?.tableView.es.stopPullToRefresh();
                self?.tableView.reloadData();
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

extension HomeVVideoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
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
        
        let model = dataSource[indexPath.row - 1] as! VVideoListModel;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: normalIdentifier) as! HomeVVideoNormalCell;
        cell.describe = model.name.string;
        cell.imageUrl = model.image.string;
        cell.videoUrl = model.video.string;
        cell.avatar = model.avatar.string;
        cell.nickname = model.nickname.string;
        cell.comment = model.commentNum.string;
        cell.isLike = model.likeStatus.int;
        cell.like = model.likeNum.string;
        //获取时间
        let timeLength = model.time.int.secondsToHoursMinutesSeconds()
        cell.videoLength = "\(timeLength.min):\(timeLength.sec)"
        cell.block = { [weak self] () in
            let vc = NETLivePlayerController(url: model.video.string)
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 188 * iPHONE_AUTORATIO;
        }
        return 250 * iPHONE_AUTORATIO;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row - 1] as! VVideoListModel;
        let vc = DetailVideoInfoController();
        vc.id = model.id.string
        vc.index = indexPath.row
        parent?.navigationController?.pushViewController(vc, animated: true)
        //如果取消点赞或者成功点赞刷新页面
        vc.favoriteBlock = { [weak self](isLike, index) in
            //获取要刷新的索引
            let changedIndexPath = IndexPath(row: index, section: 0)
            let indexPaths = [changedIndexPath]
            //更新索引的数据
            var changeModel = self?.dataSource[index-1] as! VVideoListModel
            changeModel.likeStatus.int = (isLike ? 1 : 0)
            //增加访问量
            changeModel.visitNum.int += 1
            //判断是不是喜欢
            if isLike { changeModel.likeNum.int += 1 } else { changeModel.likeNum.int -= 1 }
            self?.dataSource[index-1] = changeModel; //更新数据
            self?.tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
}

extension HomeVVideoController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "V视频", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(VVideoListResponseModel.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.topBanner(module: "V视频"), success: { [weak self] (json) in
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
