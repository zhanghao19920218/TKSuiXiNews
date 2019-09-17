//
//  CommentCommonController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/14.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let commentCellIdentifier = "DetailUserCommentCellIdentifier"

/// 评论列表

class SXCommentCommonController: BaseTableViewController {
    ///评论文章id
    var articleCommentId: Int = 0

    //banner的model
    private var _model: HomeVVideoBannerResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        
        navigationItem.title = "评论列表"
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(SXDetailUserCommentCell.self, forCellReuseIdentifier: commentCellIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none
    }
    
    
    override func loadData() {
        super.loadData();
        
        requestComListData()
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.loadMoreComment(id: articleCommentId, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXCommentListModelResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.loadMoreComment(id: articleCommentId, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXCommentListModelResponse.self, from: json)
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

extension SXCommentCommonController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataSource[indexPath.row] as! SXCommentListModelDatum
        
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier) as! SXDetailUserCommentCell
        cell.avatar = model.avatar.string
        cell.nickname = model.nickname.string
        cell.comment = model.detail.string
        cell.time = model.createtime.string
        cell.isGove = model.adminStatus.int
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! SXCommentListModelDatum
        return 59 * iPHONE_AUTORATIO + (model.detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO))
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

extension SXCommentCommonController {
    
    //MARK: - 请求评论数组
    private func requestComListData() {
        HttpClient.shareInstance.request(target: BAAPI.loadMoreComment(id: articleCommentId, page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXCommentListModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
            self?.tableView.reloadData();
            }
        )
    }
}
