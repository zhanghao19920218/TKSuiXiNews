//
//  HomeNewsListViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DefaultsKit

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
                //获取默认数据
                vc.name = Defaults.shared.get(for: placeholderKey) ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell;
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerIdentifier) as! HomeVVideoBannerCell;
            if let model = model { cell.images = model.data }
            cell.block = { [weak self] (model) in
                //如果不能显示就不跳转
                if !DefaultsKitUtil.share.isShowServer {
                    return
                }
                
                //判断文章id是否存在
                if model.articleID.int != 0 {
                    //跳转新闻的页面
                    PageJumpUtil.share.jumpVCAccording(model.articleInfo!, model.articleID)
                    return
                }
                
                //如果有外链就跳转外链
                if !model.url.string.isEmpty {
                    //跳转外链
                    let vc = ServiceWKWebViewController() //新闻播放的页面
                    vc.loadUrl = model.url.string
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                
                if !model.content.string.isEmpty {
                    let vc = HomeBannerDetailViewController()
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
            let model = dataSource[indexPath.row - 2] as! HomeNewsListModel
            if model.url.string.isEmpty {
                let vc = HomeNewsDetailInfoController();
                vc.id = model.id.string
                vc.title = "文章"
                navigationController?.pushViewController(vc, animated: true)
                //如果取消点赞或者成功点赞刷新页面
                vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                    //获取要刷新的索引
                    let indexPaths = [indexPath]
                    //更新索引的数据
                    var changeModel = self?.dataSource[indexPath.row-2] as! HomeNewsListModel
                    changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                    changeModel.commentNum.int = comment
                    changeModel.likeNum.int = like
                    changeModel.visitNum.int = review
                    self?.dataSource[indexPath.row - 2] = changeModel
                    //刷新页面
                    self?.tableView.reloadRows(at: indexPaths, with: .none)
                }
            }  else if !DefaultsKitUtil.share.isShowServer {
                let vc = HomeNewsDetailInfoController();
                vc.id = model.id.string
                vc.title = "文章"
                navigationController?.pushViewController(vc, animated: true)
                //如果取消点赞或者成功点赞刷新页面
                vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                    //获取要刷新的索引
                    let indexPaths = [indexPath]
                    //更新索引的数据
                    var changeModel = self?.dataSource[indexPath.row-2] as! HomeNewsListModel
                    changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                    changeModel.commentNum.int = comment
                    changeModel.likeNum.int = like
                    changeModel.visitNum.int = review
                    self?.dataSource[indexPath.row - 2] = changeModel
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
