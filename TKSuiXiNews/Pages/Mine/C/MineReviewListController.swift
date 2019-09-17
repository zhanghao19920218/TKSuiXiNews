//
//  MineReviewListController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let newsOnePicIdentifier = "HomeNewsOnePictureCellIdentifier"
fileprivate let newsThreePicIdentifier = "HomeNewsThreePictureCellIdentifier"
fileprivate let newsNoPicIdentifier = "HomeNewsNoPicCellIdentifier"

class MineReviewListController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        
        navigationItem.title = "最近浏览"
    }
    
    
    //初始化页面
    private func setupUI() {
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
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.recentlyReview(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXReviewListItemResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.recentlyReview(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXReviewListItemResponse.self, from: json)
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

extension MineReviewListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataSource[indexPath.row] as! SXReviewListItemModel
        
        if !model.image.string.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell;
            cell.title = model.name.string
            cell.imageName = model.image.string
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.time.string
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
            cell.time = model.time.string
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsNoPicIdentifier) as! HomeNewsNoPicCell
        cell.title = model.name.string
        cell.isLike = model.likeStatus.int
        cell.like = model.likeNum.int
        cell.review = model.visitNum.int
        cell.time = model.time.string
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! SXReviewListItemModel
        
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
        let model = dataSource[indexPath.row] as! SXReviewListItemModel
        
        if !(model.url?.string ?? "").isEmpty {
            //跳转外链
            let vc = OutlinesideWKWebViewController() //新闻播放的页面
            vc.loadUrl = model.url?.string
            vc.navigationItem.title = model.name.string
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if model.module.string == "濉溪TV" || model.module.string == "视讯"{
            //跳转濉溪TV详情
            let vc = VideoNewsDetailController()
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! SXReviewListItemModel
                changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                changeModel.commentNum.int = comment
                changeModel.likeNum.int = like
                changeModel.visitNum.int = review
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }
        } else if model.module.string == "悦听"{
            let vc = HomeHappyDetailListenController()
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! SXReviewListItemModel
                changeModel.visitNum.int = review
                changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                changeModel.likeNum.int = like
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }
        } else if model.module.string == "问政" {
            let vc = DetailAskGovementController()
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! SXReviewListItemModel
                changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                changeModel.commentNum.int = comment
                changeModel.likeNum.int = like
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }
        } else if model.module.string == "随手拍" ||  model.module.string == "原创" {
            
            if model.images.count == 0 {
                //进入视频页面
                let vc = DetailVideoInfoController()
                vc.id = model.id.string
                navigationController?.pushViewController(vc, animated: true)
                //如果取消点赞或者成功点赞刷新页面
                vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                    //获取要刷新的索引
                    let indexPaths = [indexPath]
                    //更新索引的数据
                    var changeModel = self?.dataSource[indexPath.row] as! SXReviewListItemModel
                    changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                    changeModel.commentNum.int = comment
                    changeModel.likeNum.int = like
                    changeModel.visitNum.int = review
                    self?.dataSource[indexPath.row] = changeModel
                    //刷新页面
                    self?.tableView.reloadRows(at: indexPaths, with: .none)
                }
            } else {
                //进入图文页面
                let vc = ShowDetailImageViewController();
                vc.id = model.id.string
                navigationController?.pushViewController(vc, animated: true)
                //如果取消点赞或者成功点赞刷新页面
                vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                    //获取要刷新的索引
                    let indexPaths = [indexPath]
                    //更新索引的数据
                    var changeModel = self?.dataSource[indexPath.row] as! SXReviewListItemModel
                    changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                    changeModel.commentNum.int = comment
                    changeModel.likeNum.int = like
                    changeModel.visitNum.int = review
                    self?.dataSource[indexPath.row] = changeModel
                    //刷新页面
                    tableView.reloadRows(at: indexPaths, with: .none)
                }
            }
        } else {
            let vc = HomeNewsDetailInfoController();
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! SXReviewListItemModel
                changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                changeModel.commentNum.int = comment
                changeModel.likeNum.int = like
                changeModel.visitNum.int = review
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }
        }
    }
}

extension MineReviewListController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.recentlyReview(page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXReviewListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
}
