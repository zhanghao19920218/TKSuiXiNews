//
//  MineVShootVideoController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 我的拍客帖子
 */
fileprivate let textImageIdentifier = "ShowImageTextCellIdentifier"
fileprivate let videoIdentifier = "ShowVideoViewCellIdentifier"

class MineVShootVideoController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    //初始化页面
    private func setupUI() {
        tableView.register(ShowImageTextCell.self, forCellReuseIdentifier: textImageIdentifier);
        tableView.register(ShowVideoViewCell.self, forCellReuseIdentifier: videoIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "随手拍", p: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MineArticleListModelResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "随手拍", p: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MineArticleListModelResponse.self, from: json)
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
                self?.tableView.reloadData();
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            }
        )
    }
}

extension MineVShootVideoController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "随手拍", p: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MineArticleListModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
}

extension MineVShootVideoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! MineArticleListModelDatum
        
        if model.images.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: videoIdentifier) as! ShowVideoViewCell;
            cell.describe = model.name.string;
            cell.imageUrl = model.image?.string;
            cell.videoUrl = model.video?.string ?? ""
            cell.avatar = model.avatar.string;
            cell.nickname = model.nickname.string;
            cell.comment = model.commentNum.string;
//            cell.isLike = model.likeStatus.int;
            cell.like = model.likeNum.string;
            cell.videoLength = model.time.string;
            cell.beginTime = model.time.string;
            cell.block = { [weak self] () in
                let vc = NETLivePlayerController.init(url: model.video?.string ?? "")
                self?.navigationController?.pushViewController(vc, animated: true);
            }
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: textImageIdentifier) as! ShowImageTextCell;
            cell.images = model.images;
            cell.describe = model.name.string;
            cell.avatar = model.avatar.string;
            cell.nickname = model.nickname.string;
            cell.comment = model.commentNum.string;
//            cell.isLike = model.likeStatus.int;
            cell.like = model.likeNum.string;
            cell.beginTime = model.time.string
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! MineArticleListModelDatum
        
        if model.images.isEmpty {
            return 335 * iPHONE_AUTORATIO;
        } else {
            var height:CGFloat = 0;
            if model.images.count <= 3 {
                height = 108 * iPHONE_AUTORATIO;
            } else if model.images.count <= 6 {
                height = 216 * iPHONE_AUTORATIO;
            } else {
                height = 324 * iPHONE_AUTORATIO;
            }
            return 140 * iPHONE_AUTORATIO + height ;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! MineArticleListModelDatum
        
        if model.images.count == 0 {
            //进入视频页面
            let vc = DetailVideoInfoController()
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
        } else {
            //进入图文页面
            let vc = ShowDetailImageViewController();
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

