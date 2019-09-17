//
//  MineAskGovListViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 问政记录
 */

fileprivate let askGovOneImgIdentifier = "HomeAskGovOnePicCellIdentifier"
fileprivate let askGovNoImgIdentifier = "HomeAskNonePicCellIdentifier"
fileprivate let askGovThreeImgsIdentifier = "HomeAskThreePicCellIdentifier"

class SXMineAskGovListViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "问政记录"
        
        setupUI()
    }
    
    //初始化tableView
    private func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SXHomeAskGovOnePicCell.self, forCellReuseIdentifier: askGovOneImgIdentifier)
        tableView.register(SXHomeAskNonePicCell.self, forCellReuseIdentifier: askGovNoImgIdentifier)
        tableView.register(SXHomeAskThreePicCell.self, forCellReuseIdentifier: askGovThreeImgsIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func loadData() {
        super.loadData();
        
        getHomeInfoData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "问政", p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXMineArticleListModelResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "问政", p: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXMineArticleListModelResponse.self, from: json)
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
    
    //MARK: - 点击跳转问政页面
    @objc private func didTapJumpAskGovermenyPage(_ sender: UIButton) {
        let vc = AskGovermentDetailController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SXMineAskGovListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! MineArticleListDetailModel
        
        if model.images.count == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: askGovThreeImgsIdentifier) as! SXHomeAskThreePicCell
            cell.title = model.name.string
            cell.imageName = model.images[0]
            cell.imageName2 = model.images[1]
            cell.imageName3 = model.images[2]
            cell.time = model.time.string
            cell.comment = model.commentNum.int
            return cell
        } else if !(model.image?.string ?? "").isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: askGovOneImgIdentifier) as! SXHomeAskGovOnePicCell
            cell.title = model.name.string
            cell.imageName = model.image?.string
            cell.time = model.time.string
            cell.comment = model.commentNum.int
            return cell
        } else if model.images.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: askGovOneImgIdentifier) as! SXHomeAskGovOnePicCell
            cell.title = model.name.string
            cell.imageName = model.images[0]
            cell.time = model.time.string
            cell.comment = model.commentNum.int
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: askGovNoImgIdentifier) as! SXHomeAskNonePicCell
        cell.title = model.name.string
        cell.time = model.time.string
        cell.comment = model.commentNum.int
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! MineArticleListDetailModel
        
        if !(model.image?.string ?? "").isEmpty {
            return 118 * iPHONE_AUTORATIO
        }
        
        if model.images.count == 3 {
            return 193 * iPHONE_AUTORATIO
        }
        
        return 111 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! MineArticleListDetailModel
        let vc = SXDetailAskGovementController();
        vc.id = model.id.string
        navigationController?.pushViewController(vc, animated: true)
        //如果取消点赞或者成功点赞刷新页面
        vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
            //获取要刷新的索引
            let indexPaths = [indexPath]
            //更新索引的数据
            var changeModel = self?.dataSource[indexPath.row] as! MineArticleListDetailModel
            changeModel.likeStatus.int = (likeStatus ? 1 : 0)
            changeModel.commentNum.int = comment
            changeModel.likeNum.int = like
            self?.dataSource[indexPath.row] = changeModel
            //刷新页面
            self?.tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
}


extension SXMineAskGovListViewController {
    //MARK: - 请求首页数据
    private func getHomeInfoData(){
        HttpClient.shareInstance.request(target: BAAPI.myArticle(module: "问政", p: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXMineArticleListModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
}
