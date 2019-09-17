//
//  HomeOnlineVideoNewsController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///直播新闻列表

fileprivate let cellIdentifier = "OnlineVideoTableViewCellIdentifier"

class HomeOnlineVideoNewsController: BaseTableViewController {

    //banner的model
    private var model: HomeVVideoBannerResponse?
    
    private lazy var images:[HomeVVideoBannerDatum] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(OnlineVideoTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "直播", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
            guard let forceModel = model else {
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData();
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
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "直播", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
            guard let forceModel = model else {
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
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

extension HomeOnlineVideoNewsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataSource[indexPath.row] as! HomeNewsListModel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OnlineVideoTableViewCell;
        cell.time = model.begintime.string
        cell.videoImageUrl = model.image.string
        cell.title = model.name.string
        cell.reviewNum = model.visitNum.int
        cell.playVideoBlock = { [weak self] () in
            if model.url.string.isEmpty {
                let vc = OnlineTVShowViewController(url: model.video.string)
                self?.navigationController?.pushViewController(vc, animated: true);
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 292 * iPHONE_AUTORATIO;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! HomeNewsListModel
        if model.url.string.isEmpty {
            let vc = OnlineNewsShowController();
            vc.id = model.id.string
            parent?.navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! HomeNewsListModel
                changeModel.visitNum.int = review
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }
        } else if !DefaultsKitUtil.share.isShowServer {
            let vc = HomeNewsDetailInfoController();
            vc.id = model.id.string
            vc.title = "文章"
            navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! HomeNewsListModel
                changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                changeModel.commentNum.int = comment
                changeModel.likeNum.int = like
                changeModel.visitNum.int = review
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }
        } else {
            //跳转外链
            let vc = OutlinesideWKWebViewController() //新闻播放的页面
            vc.loadUrl = model.url.string
            vc.navigationItem.title = model.name.string
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeOnlineVideoNewsController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "直播", page: page), success: { [weak self] (json) in
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
