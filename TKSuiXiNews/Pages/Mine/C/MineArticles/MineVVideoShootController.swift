//
//  MineVVideoShootController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 我的V视频
 */
fileprivate let normalIdentifier = "HomeVVideoNormalCellIdentifier";

class MineVVideoShootController: BaseTableViewController {

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
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "V视频", p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MineArticleListModelResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "V视频", p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MineArticleListModelResponse.self, from: json)
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

extension MineVVideoShootController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! MineArticleListModelDatum
        
        let cell = tableView.dequeueReusableCell(withIdentifier: normalIdentifier) as! HomeVVideoNormalCell;
        cell.describe = model.name.string;
        cell.imageUrl = model.image?.string ?? ""
        cell.videoUrl = model.video?.string ?? ""
        cell.avatar = model.avatar.string;
        cell.nickname = model.nickname.string;
        cell.comment = model.commentNum.string;
        cell.isShowDelete = true
//        cell.isLike = model.likeStatus.int;
        cell.like = model.likeNum.string;
        //获取时间
        let timeLength = model.time.int.secondsToHoursMinutesSeconds()
        cell.videoLength = "\(timeLength.min):\(timeLength.sec)"
        cell.block = { [weak self] () in
            let vc = NETLivePlayerController(url: model.video?.string ?? "")
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        cell.deleteBlock = { [weak self] () in 
            self?.deleteCurrentPageItem(with: indexPath.row)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250 * iPHONE_AUTORATIO;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! MineArticleListModelDatum
        let vc = DetailVideoInfoController();
        vc.id = model.id.string
        parent?.navigationController?.pushViewController(vc, animated: true);
    }
}

extension MineVVideoShootController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "V视频", p: page), success: { [weak self] (json) in
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
    
    //删除当前的页面数据
    private func deleteCurrentPageItem(with index: Int) {
        let model = dataSource[index] as! MineArticleListModelDatum
        //先确定是不是退出页面
        AlertPopMenu.show(title: "删除V视频", detail: "是否删除这条V视频", confirmTitle: "确定", doubleTitle: "取消", confrimBlock: { [weak self] () in
            self?.deleteVVideo(id: model.id.int)
        }) {
            
        }
    }
    
    //MARK: - 删除V视频
    private func deleteVVideo(id: Int) {
        HttpClient.shareInstance.request(target: BAAPI.deleteVVideo(id: id), success: { [weak self] (json) in
            TProgressHUD.show(text: "删除V视频成功")
            //刷新页面
            self?.pullDownRefreshData()
            }
        )
    }
    
    
}
