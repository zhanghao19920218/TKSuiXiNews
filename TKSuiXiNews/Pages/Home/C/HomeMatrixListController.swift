//
//  HomeMatrixListController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 矩阵ViewController
 */
fileprivate let titlePickIdentifier = "MatrixBannerPagerViewCellIdentifier"
fileprivate let newsOnePicIdentifier = "HomeNewsOnePictureCellIdentifier"


class HomeMatrixListController: BaseTableViewController {
    //置顶的model
    var topModel: ArticleAdminModelResponse?
    
    //设置当前的二级分类
    var secondCategory: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MatrixBannerPagerViewCell.self, forCellReuseIdentifier: titlePickIdentifier)
        tableView.register(HomeNewsOnePictureCell.self, forCellReuseIdentifier: newsOnePicIdentifier)
    }

    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
        
        requestBanner()
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.secondModule(module: "矩阵", module_second: secondCategory, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeMatrixListItemResponse.self, from: json)
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
        HttpClient.shareInstance.request(target: BAAPI.secondModule(module: "矩阵", module_second: secondCategory, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeMatrixListItemResponse.self, from: json)
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

extension HomeMatrixListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: titlePickIdentifier) as! MatrixBannerPagerViewCell
            cell.dataSources = topModel?.data ?? []
            cell.currentBlock = { [weak self] (result) in
                if result == "全部" {
                    self?.secondCategory = ""
                } else {
                    self?.secondCategory = result
                }
                self?.pullDownRefreshData() //刷新数据
            }
            return cell
        } else {
            let model = dataSource[indexPath.row] as! HomeMatrixListItemDataClassDatum
            
            let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell;
            if !model.image.string.isEmpty {
                cell.title = model.name.string
                cell.imageName = model.image.string
                cell.like = model.likeNum.int
                cell.review = model.visitNum.int
                cell.isLike = model.likeStatus.int
            }
            return cell;
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 139 * iPHONE_AUTORATIO
        }
        return 112 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let model = dataSource[indexPath.row] as! HomeMatrixListItemDataClassDatum
            let vc = HomeNewsDetailInfoController()
            vc.id = model.id.string
            vc.title = "矩阵"
            navigationController?.pushViewController(vc, animated: true)
            //如果取消点赞或者成功点赞刷新页面
            vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
                //获取要刷新的索引
                let indexPaths = [indexPath]
                //更新索引的数据
                var changeModel = self?.dataSource[indexPath.row] as! HomeMatrixListItemDataClassDatum
                changeModel.likeStatus.int = (likeStatus ? 1 : 0)
                changeModel.commentNum.int = comment
                changeModel.likeNum.int = like
                changeModel.visitNum.int = review
                self?.dataSource[indexPath.row] = changeModel
                //刷新页面
                tableView.reloadRows(at: indexPaths, with: .none)
            }
        }
    }
}

extension HomeMatrixListController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.secondModule(module: "矩阵", module_second: secondCategory, page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeMatrixListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
            self?.tableView.reloadData()
            }
        )
    }
    
    //MARK: - 请求矩阵
    private func requestBanner() {
        HttpClient.shareInstance.request(target: BAAPI.articleAdmin(module: "矩阵"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ArticleAdminModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.topModel = forceModel
            //刷新矩阵号页面
            self?.tableView.reloadData();
            }
        )
    }
}
